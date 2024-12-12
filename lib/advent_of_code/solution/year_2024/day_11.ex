defmodule AdventOfCode.Solution.Year2024.Day11 do
  def part1(input) do
    input
    |> String.split()
    |> blink(25)
    |> length()
  end

  def part2(input) do
    input
    |> String.split()
    |> Enum.reduce(%{}, fn stone, map ->
      Map.update(map, stone, 1, & &1+1)
    end)
    |> blink(75)
  end

  defp blink(%{} = stones, 0), do: stones |> Map.values() |> Enum.sum()
  defp blink(%{} = stones, n) do
    stones
    |> Enum.reduce(%{}, fn {stone, number}, new_map ->
      stone
      |> transform_stone()
      |> Enum.reduce(new_map, fn new_stone, new_map ->
        Map.update(new_map, new_stone, number, & &1+number)
      end)
    end)
    |> blink(n-1)
  end

  defp blink(stones, 0), do: stones
  defp blink(stones, n) do
    blink(Enum.flat_map(stones, &transform_stone(&1)), n-1)
  end

  defp transform_stone("0"), do: ["1"]
  defp transform_stone(stone) do
    stone_length = String.length(stone)
    if rem(stone_length, 2) == 0 do
      stone
      |> String.split_at(div(stone_length, 2))
      |> Tuple.to_list()
      |> Enum.map(&remove_leading_zeroes/1)
    else
      ["#{String.to_integer(stone)*2024}"]
    end
  end

  defp remove_leading_zeroes(string) do
    case String.replace_leading(string, "0", "") do
      "" -> "0"
      n -> n
    end
  end
end
