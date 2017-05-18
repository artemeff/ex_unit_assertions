defmodule ExUnitAssertionsTest do
  use ExUnit.Case

  import ExUnitAssertions

  describe "#match_in?" do
    test "returns matched entry from list by pattern" do
      return = match_in? %{a: 1}, [%{a: 0, b: 0}, %{a: 1, b: 2}, %{a: 2, b: 3}]

      assert %{a: 1, b: 2} == return
    end

    test "simple list" do
      assert match_in? 1, [1, 2, 3]
    end

    test "complex pattern" do
      assert match_in? %{a: 1}, [%{a: 0, b: 0}, %{a: 1, b: 2}, %{a: 2, b: 3}]
    end

    test "fails" do
      assert_raise ExUnit.AssertionError, fn ->
        match_in? 1, [2, 3, 4]
      end

      assert_raise ExUnit.AssertionError, fn ->
        match_in? %{a: 1}, [%{a: 2, b: 2}, %{a: 2, b: 3}]
      end
    end

    test "with pinned variables" do
      a = 1

      assert match_in? ^a, [1, 2, 3]
      assert match_in? %{a: ^a}, [%{a: 1, b: 2}, %{a: 2, b: 3}]
    end

    test "with bounds" do
      assert match_in? %{a: 1, b: b1}, [%{a: 1, b: 2}, %{a: 2, b: 3}]
      assert match_in? %{a: 2, b: b2}, [%{a: 1, b: 2}, %{a: 2, b: 3}]

      assert b1 == 2
      assert b2 == 3
    end
  end
end
