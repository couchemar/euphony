defmodule Euphony.Quark.Server do
  use GenServer.Behaviour
  import GenX.GenServer

  defrecord State, key: nil,
                   value: nil,
                   version: 0

  def start_link(key, value) do
    :gen_server.start_link __MODULE__, [key, value], []
  end

  def start_link(space, key, value) do
    :gen_server.start_link __MODULE__, [space, key, value], []
  end

  def init([key, value]) do
    :gproc.add_local_name {:quark, key}
    notify_create(key, value, 0)
    {:ok, State.new(value: value, key: key)}
  end

  def init([space, key, value]) do
    :gproc.add_local_name {:quark, {space, key}}
    :gproc.add_local_property {:space, space}, key
    notify_create(key, value, 0)
    {:ok, State.new(value: value, key: key)}
  end

  defcall get, state: State[value: value,
                            version: version] = state do
    {:reply, {value, version}, state}
  end

  defcall set(value),
          state: State[key: key,
                       value: old_value,
                       version: version] = state do
    new_version = version + 1
    notify_update(key, old_value, value, new_version)
    {:reply, :ok, state.value(value).version(new_version)}
  end

  defcall compare_and_set(value, expected_value),
          state: State[key: key,
                       value: old_value,
                       version: version] = state do
    if expected_value == old_value do
      new_version = version + 1
      notify_update(key, old_value, value, new_version)
      {:reply, :ok, state.value(value).version(new_version)}
    else
      {:reply, :not_match, state}
    end
  end

  defp notify_update(key, old_value, new_value, new_version) do
    :gproc_ps.publish(:l, {:update, key}, {old_value, new_value, new_version})
  end

  defp notify_create(key, value, version) do
    :gproc_ps.publish(:l, :create, {key, value, version})
  end

end