defmodule ExUnitAssertionsTest do
  use ExUnit.Case
  doctest ExUnitAssertions

  test "the truth" do
    assert 1 + 1 == 2
  end
end
