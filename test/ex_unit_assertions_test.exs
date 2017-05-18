defmodule ExUnitAssertionsTest do
  use ExUnit.Case

  import ExUnitAssertions

  describe "#assert_match_in?" do
    test "simple list" do
      assert 1 == assert_match_in? 1, [1, 2, 3]
    end

    test "complex pattern" do
      assert %{a: 1, b: 2}
          == assert_match_in? %{a: 1}, [%{a: 0, b: 0}, %{a: 1, b: 2}, %{a: 2, b: 3}]
    end

    test "fails" do
      assert_raise ExUnit.AssertionError, fn ->
        assert_match_in? 1, [2, 3, 4]
      end

      assert_raise ExUnit.AssertionError, fn ->
        assert_match_in? %{a: 1}, [%{a: 2, b: 2}, %{a: 2, b: 3}]
      end
    end

    test "with pinned variables" do
      a = 1

      assert 1
          == assert_match_in? ^a, [1, 2, 3]

      assert %{a: 1, b: 2}
          == assert_match_in? %{a: ^a}, [%{a: 1, b: 2}, %{a: 2, b: 3}]
    end

    test "with bounds" do
      assert_match_in? %{a: 1, b: b1}, [%{a: 1, b: 2}, %{a: 2, b: 3}]
      assert_match_in? %{a: 2, b: b2}, [%{a: 1, b: 2}, %{a: 2, b: 3}]

      assert b1 == 2
      assert b2 == 3
    end
  end
end
