defmodule AdventOfCode.Solution.Year2024.Day10 do
  alias AdventOfCode.CharGrid

  @next_value %{
    ?0 => ?1,
    ?1 => ?2,
    ?2 => ?3,
    ?3 => ?4,
    ?4 => ?5,
    ?5 => ?6,
    ?6 => ?7,
    ?7 => ?8,
    ?8 => ?9
  }

  def part1(input) do
    map = CharGrid.from_input(input)

    map
    |> CharGrid.filter_cells(fn {_coords, val} -> val == ?0 end)
    |> Enum.reduce(0, fn {start, ?0}, sum ->
      sum + MapSet.size(find_endings(map, start, ?0))
    end)
  end

  defp find_endings(_map, cell, ?9) do
    MapSet.new([cell])
  end

  defp find_endings(map, cell, value) do
    next_value = @next_value[value]

    map
    |> CharGrid.adjacent_cells(cell, :cardinal)
    |> Enum.filter(fn {_coords, value} -> value == next_value end)
    |> Enum.reduce(MapSet.new(), fn {coords, ^next_value}, mapset ->
      MapSet.union(mapset, find_endings(map, coords, next_value))
    end)
  end

  def part2(input) do
    map = CharGrid.from_input(input)

    map
    |> CharGrid.filter_cells(fn {_coords, val} -> val == ?0 end)
    |> Enum.reduce(0, fn {start, ?0}, sum ->
      sum + sum_trails(map, start, ?0)
    end)
  end

  defp sum_trails(_map, _cell, ?9) do
    1
  end

  defp sum_trails(map, cell, value) do
    next_value = @next_value[value]

    map
    |> CharGrid.adjacent_cells(cell, :cardinal)
    |> Enum.filter(fn {_coords, value} -> value == next_value end)
    |> Enum.reduce(0, fn {coords, ^next_value}, total ->
      total + sum_trails(map, coords, next_value)
    end)
  end
end
