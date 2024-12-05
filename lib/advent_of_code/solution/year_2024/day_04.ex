defmodule AdventOfCode.Solution.Year2024.Day04 do
  @directions [:N, :NE, :E, :SE, :S, :SW, :W, :NW]
  @letters %{
    "X" => "M",
    "M" => "A",
    "A" => "S"
  }

  def part1(input) do
    array = parse_to_array(input)

    Enum.reduce(0..(length(array) - 1), 0, fn y, total ->
      total +
        Enum.reduce(0..(length(Enum.at(array, 0)) - 1), 0, fn x, row_total ->
          row_total + matches_starting_at(array, x, y)
        end)
    end)
  end

  def part2(input) do
    array = parse_to_array(input)

    Enum.reduce(0..(length(array) - 1), 0, fn y, total ->
      total +
        Enum.reduce(0..(length(Enum.at(array, 0)) - 1), 0, fn x, row_total ->
          row_total + if cross_matches_starting_at(array, x, y), do: 1, else: 0
        end)
    end)
  end

  defp cross_matches_starting_at(array, x, y) do
    letter_at_equals(array, x, y, "A") &&
      ((letter_at_equals(array, x - 1, y - 1, "M") &&
          letter_at_equals(array, x + 1, y + 1, "S")) ||
         (letter_at_equals(array, x - 1, y - 1, "S") &&
            letter_at_equals(array, x + 1, y + 1, "M"))) &&
      ((letter_at_equals(array, x + 1, y - 1, "M") &&
          letter_at_equals(array, x - 1, y + 1, "S")) ||
         (letter_at_equals(array, x + 1, y - 1, "S") &&
            letter_at_equals(array, x - 1, y + 1, "M")))
  end

  defp matches_starting_at(array, x, y) do
    Enum.reduce(@directions, 0, fn direction, total ->
      total + check_letter(array, x, y, "X", direction)
    end)
  end

  defp check_letter(_, _, _, nil, _), do: 1

  defp check_letter(array, x, y, letter, direction) do
    if letter_at_equals(array, x, y, letter) do
      {new_x, new_y} = move_in_direction(x, y, direction)
      new_letter = next_letter(letter)
      check_letter(array, new_x, new_y, new_letter, direction)
    else
      0
    end
  end

  defp next_letter(old_letter), do: Map.get(@letters, old_letter)

  defp move_in_direction(x, y, :N), do: {x, y - 1}
  defp move_in_direction(x, y, :NE), do: {x + 1, y - 1}
  defp move_in_direction(x, y, :E), do: {x + 1, y}
  defp move_in_direction(x, y, :SE), do: {x + 1, y + 1}
  defp move_in_direction(x, y, :S), do: {x, y + 1}
  defp move_in_direction(x, y, :SW), do: {x - 1, y + 1}
  defp move_in_direction(x, y, :W), do: {x - 1, y}
  defp move_in_direction(x, y, :NW), do: {x - 1, y - 1}

  defp letter_at_equals(array, x, y, letter) do
    x >= 0 && y >= 0 &&
      array
      |> Enum.at(y, [])
      |> Enum.at(x, 1)
      |> Kernel.==(letter)
  end

  defp parse_to_array(string) do
    string
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
  end
end
