Code.require_file "test_helper.exs", __DIR__

defmodule QuarkTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, _pid} = Euphony.Quark.Supervisor.start_link
    :ok
  end

  test "set get cas" do
    assert Euphony.Quark.set(1, 1) == :ok
    assert Euphony.Quark.get(1) == {1, 0}

    assert Euphony.Quark.set(1, 5) == :ok
    assert Euphony.Quark.get(1) == {5, 1}

    assert Euphony.Quark.cas(1, 6, 5) == :ok
    assert Euphony.Quark.get(1) == {6, 2}

    assert Euphony.Quark.get(2) == :not_exists
    assert Euphony.Quark.cas(2, 5, 5) == :not_exists

    assert Euphony.Quark.cas(1, 5, 5) == :not_match
  end

end