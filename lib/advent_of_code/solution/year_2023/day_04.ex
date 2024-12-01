defmodule AdventOfCode.Solution.Year2023.Day04 do
  def part1(input) do
    input
    |> map_to_wins()
    |> Enum.map(&get_score/1)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> map_to_wins()
    |> Enum.map(&{&1, 1})
    |> total_scorecards()
    |> IO.inspect()
  end

  defp total_scorecards([]), do: 0

  defp total_scorecards([{0, times} | rest]) do
    times + total_scorecards(rest)
  end

  defp total_scorecards([{wins, times} | rest]) do
    new_rest =
      Enum.reduce(0..(wins - 1), rest, fn i, acc ->
        List.update_at(acc, i, fn {w, t} -> {w, t + times} end)
      end)

    times + total_scorecards(new_rest)
  end

  defp map_to_wins(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn card ->
      [winning, yours] =
        Regex.run(~r/Card +\d+: ([\d ]+)\|([\d ]+)/, card, capture: :all_but_first)

      winning_numbers = winning |> String.split() |> Enum.map(&String.to_integer/1)
      your_numbers = yours |> String.split() |> Enum.map(&String.to_integer/1)

      your_numbers
      |> Enum.filter(&(&1 in winning_numbers))
      |> Kernel.length()
    end)
  end

  defp get_score(0), do: 0
  defp get_score(x), do: Integer.pow(2, x - 1)
end
