Code.require_file "test_helper.exs", __DIR__

defmodule QuarkTest do
  use ExUnit.Case, async: true

  setup_all do
    {:ok, _pid} = Euphony.Quark.Supervisor.start_link
    :ok
  end

  test "single" do
    assert Euphony.Quark.set(1, 1) == :not_exists

    assert {:ok, _pid} = Euphony.Quark.create(1, 1)
    assert Euphony.Quark.create(1, 1) == :already_exists

    assert Euphony.Quark.get(1) == {1, 0}

    assert Euphony.Quark.set(1, 5) == :ok
    assert Euphony.Quark.get(1) == {5, 1}

    assert Euphony.Quark.cas(1, 6, 5) == :ok
    assert Euphony.Quark.get(1) == {6, 2}

    assert Euphony.Quark.get(2) == :not_exists
    assert Euphony.Quark.cas(2, 5, 5) == :not_exists

    assert Euphony.Quark.cas(1, 5, 5) == :not_match
  end

  test "in space" do
    assert Euphony.Quark.set(1, 1, 1) == :not_exists

    assert {:ok, _pid} = Euphony.Quark.create(1, 1, 1)
    assert Euphony.Quark.create(1, 1, 1) == :already_exists

    assert Euphony.Quark.get(1, 1) == {1, 0}

    assert Euphony.Quark.set(1, 1, 5) == :ok
    assert Euphony.Quark.get(1, 1) == {5, 1}

    assert Euphony.Quark.cas(1, 1, 6, 5) == :ok
    assert Euphony.Quark.get(1, 1) == {6, 2}

    assert Euphony.Quark.get(1, 2) == :not_exists
    assert Euphony.Quark.cas(1, 2, 5, 5) == :not_exists

    assert Euphony.Quark.cas(1, 1, 5, 5) == :not_match
  end

end