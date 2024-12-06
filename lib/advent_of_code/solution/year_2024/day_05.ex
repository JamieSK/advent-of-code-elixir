defmodule AdventOfCode.Solution.Year2024.Day05 do
  def part1(input) do
    {rules, updates} = parse_input(input)

    updates
    |> Enum.map(fn update ->
      if sort_update_by_rules(update, rules) == update do
        get_middle_value(update)
      else
        0
      end
    end)
    |> Enum.sum()
  end

  def part2(input) do
    {rules, updates} = parse_input(input)

    updates
    |> Enum.map(fn update ->
      sorted_update = sort_update_by_rules(update, rules)

      if sorted_update == update do
        0
      else
        get_middle_value(sorted_update)
      end
    end)
    |> Enum.sum()
  end

  defp parse_input(input) do
    [rules | [updates | _]] = String.split(input, "\n\n")

    rules =
      rules
      |> String.split("\n")
      |> Enum.map(fn rule ->
        [pre | [post | _]] = String.split(rule, "|", trim: true)
        {String.to_integer(pre), String.to_integer(post)}
      end)

    updates =
      updates
      |> String.split("\n", trim: true)
      |> Enum.map(
        &(String.split(&1, ",", trim: true)
          |> Enum.map(fn x -> String.to_integer(x) end))
      )

    {rules, updates}
  end

  defp sort_update_by_rules(update, rules) do
    Enum.sort(update, fn n1, n2 ->
      case Enum.find(rules, &({n1, n2} == &1 || {n2, n1} == &1)) do
        {^n1, ^n2} -> true
        {^n2, ^n1} -> false
        nil -> true
      end
    end)
  end

  defp get_middle_value(list), do: Enum.at(list, Integer.floor_div(length(list), 2))
end
