defmodule AdventOfCode.Solution.Year2023.Day01 do
  @match_string "1|2|3|4|5|6|7|8|9|one|two|three|four|five|six|seven|eight|nine"
  @forward_regex Regex.compile!(@match_string)
  @backward_regex Regex.compile!(String.reverse(@match_string))

  def part1(input) do
    input
    |> String.split()
    |> Enum.map(fn line ->
      line
      |> String.graphemes()
      |> Enum.map(&Integer.parse/1)
      |> Enum.filter(&match?({_, ""}, &1))
      |> Enum.map(&elem(&1, 0))
    end)
    |> Enum.map(fn list ->
      concat = "#{List.first(list)}#{List.last(list)}"
      {num, ""} = Integer.parse(concat)
      num
    end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> String.split()
    |> Enum.map(fn line ->
      first = Regex.run(@forward_regex, line, capture: :first) |> hd() |> to_num()

      last =
        Regex.run(@backward_regex, String.reverse(line), capture: :first)
        |> hd()
        |> String.reverse()
        |> to_num()

      concat = "#{first}#{last}"
      {num, ""} = Integer.parse(concat)
      num
    end)
    |> Enum.sum()
  end

  defp to_num("one"), do: "1"
  defp to_num("two"), do: "2"
  defp to_num("three"), do: "3"
  defp to_num("four"), do: "4"
  defp to_num("five"), do: "5"
  defp to_num("six"), do: "6"
  defp to_num("seven"), do: "7"
  defp to_num("eight"), do: "8"
  defp to_num("nine"), do: "9"
  defp to_num(d), do: d
end
