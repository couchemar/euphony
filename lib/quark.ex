defmodule Euphony.Quark do

  def set(key, value) do
    case :gproc.lookup_local_name {:quark, key} do
      :undefined -> Euphony.Quark.Supervisor.create key, value
      pid -> Euphony.Quark.Server.set pid, value
    end
    :ok
  end

  def get(key) do
    case :gproc.lookup_local_name {:quark, key} do
      :undefined -> :undefined
      pid -> Euphony.Quark.Server.get pid
    end
  end

end