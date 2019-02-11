defmodule EnvCoreTest do
  use ExUnit.Case
  doctest EnvCore

  test "greets the world" do
    assert EnvCore.hello() == :world
  end
end
