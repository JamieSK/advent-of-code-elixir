defmodule AdventOfCode.Solution.Year2023.Day02 do
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [id, plays] =
        Regex.run(~r/Game (?<id>\d+): ((?:\d+ (?:blue|red|green),?;? ?)+)/, line,
          capture: :all_but_first
        )

      valid_game =
        String.split(plays, ~r/[,;]/, trim: true)
        |> Enum.map(fn play ->
          [num, colour] = Regex.run(~r/ ?(\d+) (red|green|blue)/, play, capture: :all_but_first)
          num = String.to_integer(num)

          case colour do
            "blue" -> num <= 14
            "green" -> num <= 13
            "red" -> num <= 12
          end
        end)
        |> Enum.all?()

      if valid_game, do: String.to_integer(id), else: 0
    end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [_id, plays] =
        Regex.run(~r/Game (?<id>\d+): ((?:\d+ (?:blue|red|green),?;? ?)+)/, line,
          capture: :all_but_first
        )

      String.split(plays, ~r/[,;]/, trim: true)
      |> Enum.reduce({0, 0, 0}, fn play, {r, g, b} ->
        [num, colour] = Regex.run(~r/ ?(\d+) (red|green|blue)/, play, capture: :all_but_first)
        num = String.to_integer(num)

        case colour do
          "red" -> {max(r, num), g, b}
          "green" -> {r, max(g, num), b}
          "blue" -> {r, g, max(b, num)}
        end
      end)
      |> Tuple.product()
    end)
    |> Enum.sum()
  end
end
