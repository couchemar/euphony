defmodule Euphony.Quark.Supervisor do
  use Supervisor.Behaviour

  def start_link do
    :supervisor.start_link {:local, __MODULE__}, __MODULE__, []
  end

  def init([]) do
    children = [worker(Euphony.Quark.Server, [])]
    supervise children, strategy: :simple_one_for_one
  end

  def create(key, value) do
    :supervisor.start_child __MODULE__, [key, value]
  end

  def create(space, key, value) do
    :supervisor.start_child __MODULE__, [space, key, value]
  end

end