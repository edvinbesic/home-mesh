defmodule HomeMeshGatewayTest do
  use ExUnit.Case
  doctest HomeMeshGateway

  test "greets the world" do
    assert HomeMeshGateway.hello() == :world
  end
end
