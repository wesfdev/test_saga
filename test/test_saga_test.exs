defmodule TestSagaTest do
  use ExUnit.Case
  doctest TestSaga

  test "greets the world" do
    assert TestSaga.hello() == :world
  end
end
