defmodule Euphony.Quark do

  def create(key, value) do
    case :gproc.lookup_local_name {:quark, key} do
      :undefined -> Euphony.Quark.Supervisor.create key, value
      _pid -> :already_exists
    end
  end

  def create(space, key, value) do
    case :gproc.lookup_local_name {:quark, {space, key}} do
      :undefined -> Euphony.Quark.Supervisor.create space, key, value
      _pid -> :already_exists
    end
  end

  def set(key, value) do
    case :gproc.lookup_local_name {:quark, key} do
      :undefined -> :not_exists
      pid -> Euphony.Quark.Server.set pid, value
    end
  end
  def set(space, key, value), do: set({space, key}, value)

  def get(key) do
    case :gproc.lookup_local_name {:quark, key} do
      :undefined -> :not_exists
      pid -> Euphony.Quark.Server.get pid
    end
  end
  def get(space, key), do: get({space, key})

  def cas(key, value, expected_value) do
    case :gproc.lookup_local_name {:quark, key} do
      :undefined -> :not_exists
      pid -> Euphony.Quark.Server.compare_and_set pid, value, expected_value
    end
  end
  def cas(space, key, value, expected_value), do: cas({space, key}, value, expected_value)

end