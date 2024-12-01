defmodule AdventOfCode.Solution.Year2024.Day01 do
  def part1(input) do
    {list_1, list_2} =
      input
      |> String.split("\n", trim: true)
      |> Enum.reduce({[], []}, fn line, {list_1, list_2} ->
        [num_1, num_2] = String.split(line, " ", trim: true)
        {[String.to_integer(num_1) | list_1], [String.to_integer(num_2) | list_2]}
      end)

    Enum.zip_reduce(Enum.sort(list_1), Enum.sort(list_2), 0, fn x, y, acc ->
      abs(x - y) + acc
    end)
  end

  def part2(input) do
    {list_1, list_2} =
      input
      |> String.split("\n", trim: true)
      |> Enum.reduce({[], []}, fn line, {list_1, list_2} ->
        [num_1, num_2] = String.split(line, " ", trim: true)
        {[String.to_integer(num_1) | list_1], [String.to_integer(num_2) | list_2]}
      end)

    freqs = Enum.frequencies(list_2)

    Enum.reduce(list_1, 0, fn num, total ->
      total + num * Map.get(freqs, num, 0)
    end)
  end
end
