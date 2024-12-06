defmodule AdventOfCode.Solution.Year2024.Day06 do
  alias AdventOfCode.CharGrid

  @dir_bits %{
    ?> => 1,
    ?v => 2,
    ?< => 4,
    ?^ => 8
  }

  @non_dir_chars [?>, ?v, ?<, ?^, ?., ?#, ?O]

  def part1(input) do
    map = CharGrid.from_input(input)
    {{x, y}, _} = guard = CharGrid.filter_cells(map, fn {_coords, char} -> char == ?^ end) |> hd()

    map
    |> update_grid({{x, y}, ?.})
    |> move_guard(guard)
    |> tap(&print_map/1)
    |> CharGrid.count(fn {_, val} -> val in 1..15 end)
  end

  def part2(input) do
    map = CharGrid.from_input(input)
    {{x, y}, _} = guard = CharGrid.filter_cells(map, fn {_coords, char} -> char == ?^ end) |> hd()

    map = update_grid(map, {{x, y}, ?.})

    map
    |> move_guard(guard)
    |> CharGrid.filter_cells(fn {_, char} -> char in 1..15 end)
    |> Enum.reject(fn {c, _} -> c == {x, y} end)
    |> Enum.reduce(0, fn {{x, y}, _}, total ->
      if map
         |> update_grid({{x, y}, ?O})
         |> move_guard(guard) == :loop do
        total + 1
      else
        total
      end
    end)
  end

  defp move_guard(%{width: w} = map, {{x, y}, ?>} = guard) when w == x + 1,
    do: map |> update_grid({{x, y}, add_pass_to_cell(map, guard)})

  defp move_guard(%{height: h} = map, {{x, y}, ?v} = guard) when h == y + 1,
    do: map |> update_grid({{x, y}, add_pass_to_cell(map, guard)})

  defp move_guard(map, {{0, y}, ?<} = guard),
    do: map |> update_grid({{0, y}, add_pass_to_cell(map, guard)})

  defp move_guard(map, {{x, 0}, ?^} = guard),
    do: map |> update_grid({{x, 0}, add_pass_to_cell(map, guard)})

  defp move_guard(map, {{x, y}, guard_char} = guard) do
    next_coord = next_coord(guard)
    next_char = CharGrid.at(map, next_coord)

    cond do
      next_char not in @non_dir_chars && Bitwise.band(next_char, @dir_bits[guard_char]) != 0 ->
        :loop

      next_char == ?# || next_char == ?O ->
        turn_guard(map, guard)

      true ->
        map
        |> update_grid({{x, y}, add_pass_to_cell(map, guard)})
        |> move_guard({next_coord, guard_char})
    end
  end

  defp add_pass_to_cell(map, {{x, y}, dir}) do
    case CharGrid.at(map, {x, y}) do
      ?. -> @dir_bits[dir]
      other_char -> other_char + @dir_bits[dir]
    end
  end

  defp next_coord({{x, y}, ?>}), do: {x + 1, y}
  defp next_coord({{x, y}, ?v}), do: {x, y + 1}
  defp next_coord({{x, y}, ?<}), do: {x - 1, y}
  defp next_coord({{x, y}, ?^}), do: {x, y - 1}

  defp turn_guard(map, {{x, y}, guard_char}) do
    new_guard_char = Map.get(%{?^ => ?>, ?> => ?v, ?v => ?<, ?< => ?^}, guard_char)
    move_guard(map, {{x, y}, new_guard_char})
  end

  defp update_grid(map, {{x, y}, val}) do
    %{map | grid: Map.put(map.grid, {x, y}, val)}
  end

  defp print_map(map) do
    map
    |> CharGrid.map(fn {_, val} ->
      case val do
        1 -> ?-
        2 -> ?|
        3 -> ?+
        4 -> ?-
        5 -> ?+
        6 -> ?+
        7 -> ?+
        8 -> ?|
        9 -> ?+
        10 -> ?|
        11 -> ?+
        12 -> ?+
        13 -> ?+
        14 -> ?+
        15 -> ?+
        x -> x
      end
    end)
    |> CharGrid.print()
  end
end
