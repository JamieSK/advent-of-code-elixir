defmodule AdventOfCode.Solution.Year2024.Day03 do
  def part1(input) do
    ~r/mul\((\d+),(\d+)\)/ 
    |> Regex.scan(input, capture: :all_but_first)
    |> Enum.map(&Enum.map(&1, fn s -> String.to_integer(s) end))
    |> Enum.map(&Enum.product/1)
    |> Enum.sum()
  end

  def part2(input) do
    ~r/do\(\)/
    |> Regex.split(input)
    |> Enum.map(fn x -> hd(Regex.split(~r/don't\(\)/, x)) end)
    |> Enum.map(&part1/1)
    |> Enum.sum()
  end
end
