defmodule Euphony.Quark.Server do
  use GenServer.Behaviour
  import GenX.GenServer

  defrecord State, key: nil,
                   value: nil,
                   version: 0

  def start_link(key, value) do
    :gen_server.start_link __MODULE__, [key, value], []
  end

  def init([key, value]) do
    :gproc.reg {:n, :l, {:quark, key}}
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
    notify(key, old_value, value, new_version)
    {:reply, :ok, state.value(value).version(new_version)}
  end

  defp notify(key, old_value, new_value, new_version) do
    :gproc_ps.publish(:l, {:update, key}, {old_value, new_value, new_version})
  end

end