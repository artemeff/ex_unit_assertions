defmodule ExUnitAssertions do
  @doc """
  Matches pattern in list:

      > match_in?(1, [1, 2, 3])
      1

      > match_in?(%{a: 1}, [%{a: 1, b: 2}, %{a: 2, b: 3}])
      %{a: 1, b: 2}

      > match_in?(%{a: 1}, [%{a: 2, b: 2}, %{a: 2, b: 3}])
      raised error

      > a = 1
      > match_in?(%{a: ^a}, [%{a: 1, b: 2}, %{a: 2, b: 3}])
      %{a: 1, b: 2}

      > match_in?(%{a: 1, b: b}, [%{a: 1, b: 2}, %{a: 2, b: 3}])
      %{a: 1, b: 2}
      > b
      2
  """
  @spec match_in?(term, list(term)) :: true | false
  defmacro match_in?(pattern, expr) do
    left = Macro.expand(pattern, __CALLER__)
    vars = collect_vars_from_pattern(left)
    pins = collect_pins_from_pattern(left)

    quote do
      left = unquote(Macro.escape(left))
      expr = unquote(expr)

      matching =
        Enum.reduce(expr, nil, fn
          (element, nil) ->
            case element do
              unquote(pattern) ->
                _ = unquote(vars)
                element
              _ ->
                nil
            end
          (element, acc) ->
            acc
        end)

      if is_nil(matching) do
        raise ExUnit.AssertionError,
          right: expr,
          expr: left,
          message: "match_in? failed" <>
                    ExUnit.Assertions.__pins__(unquote(pins))
      end

      unquote(pattern) = matching
    end
  end

  defp collect_vars_from_pattern({:when, _, [left, right]}) do
    pattern = collect_vars_from_pattern(left)
    for {name, _, context} = var <- collect_vars_from_pattern(right),
      Enum.any?(pattern, &match?({^name, _, ^context}, &1)),
      into: pattern,
      do: var
  end

  defp collect_vars_from_pattern(expr) do
    Macro.prewalk(expr, [], fn
      {:::, _, [left, _]}, acc ->
        {[left], acc}
      {skip, _, [_]}, acc when skip in [:^, :@] ->
        {:ok, acc}
      {:_, _, context}, acc when is_atom(context) ->
        {:ok, acc}
      {name, meta, context}, acc when is_atom(name) and is_atom(context) ->
        {:ok, [{name, [generated: true] ++ meta, context} | acc]}
      node, acc ->
        {node, acc}
    end)
    |> elem(1)
  end

  defp collect_pins_from_pattern(expr) do
    {_, pins} =
      Macro.prewalk(expr, [], fn
        {:^, _, [{name, _, _} = var]}, acc ->
          {:ok, [{name, var} | acc]}
        form, acc ->
          {form, acc}
      end)
    Enum.uniq_by(pins, &elem(&1, 0))
  end
end
