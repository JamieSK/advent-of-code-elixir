defmodule AdventOfCode.Solution.Year2024.Day07 do
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      {goal, possibilities} =
        Regex.scan(~r/(\d+)/, line, capture: :all_but_first)
        |> List.flatten()
        |> Enum.map(&String.to_integer/1)
        |> check_line([:plus, :times])

      if Enum.any?(possibilities), do: goal, else: 0
    end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      {goal, possibilities} =
        Regex.scan(~r/(\d+)/, line, capture: :all_but_first)
        |> List.flatten()
        |> Enum.map(&String.to_integer/1)
        |> check_line([:plus, :times, :concat])

      if Enum.any?(possibilities), do: goal, else: 0
    end)
    |> Enum.sum()
  end

  defp check_line([goal | nums], operators), do: construct_sum(goal, nums, [], operators)

  defp construct_sum(goal, [], sums, _), do: {goal, Enum.map(sums, &check_sum(goal, &1))}

  defp construct_sum(goal, [next_num | nums], [], operators),
    do: construct_sum(goal, nums, [[next_num]], operators)

  defp construct_sum(goal, [next_num | nums], sums, operators) do
    construct_sum(
      goal,
      nums,
      Enum.flat_map(sums, fn sum ->
        Enum.map(operators, fn operator -> sum ++ [operator, next_num] end)
      end),
      operators
    )
  end

  defp check_sum(goal, [num | rest]), do: check_sum(goal, num, rest)

  defp check_sum(goal, total, _) when total > goal, do: false
  defp check_sum(goal, total, []), do: total == goal
  defp check_sum(goal, total, [:plus, next | rest]), do: check_sum(goal, total + next, rest)
  defp check_sum(goal, total, [:times, next | rest]), do: check_sum(goal, total * next, rest)

  defp check_sum(goal, total, [:concat, next | rest]),
    do: check_sum(goal, String.to_integer("#{total}#{next}"), rest)
end
