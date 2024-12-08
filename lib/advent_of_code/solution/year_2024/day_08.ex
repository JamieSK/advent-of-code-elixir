defmodule AdventOfCode.Solution.Year2024.Day08 do
  alias AdventOfCode.CharGrid

  def part1(input) do
    map = CharGrid.from_input(input)

    map
    |> Map.get(:grid)
    |> Enum.group_by(fn {_, v} -> v end, fn {c, _} -> c end)
    |> Map.drop([?.])
    |> Map.values()
    |> Enum.map(&comb(2, &1))
    |> List.flatten()
    |> Enum.chunk_every(2)
    |> Enum.reduce(map, fn [{x1, y1}, {x2, y2}], map ->
      diff_x = x1 - x2
      diff_y = y1 - y2

      map
      |> CharGrid.update_grid({{x1 + diff_x, y1 + diff_y}, ?#})
      |> CharGrid.update_grid({{x2 - diff_x, y2 - diff_y}, ?#})
    end)
    |> CharGrid.count_chars(?#)
  end

  def part2(input) do
    map = CharGrid.from_input(input)

    map
    |> Map.get(:grid)
    |> Enum.group_by(fn {_, v} -> v end, fn {c, _} -> c end)
    |> Map.drop([?.])
    |> Map.values()
    |> Enum.map(&comb(2, &1))
    |> List.flatten()
    |> Enum.chunk_every(2)
    |> Enum.reduce(map, fn [{x1, y1}, {x2, y2}], map ->
      diff_x = x1 - x2
      diff_y = y1 - y2

      Enum.reduce_while(1..1000, map, fn n, map ->
        {x, y} = coords = {x1 + n*diff_x, y1 + n*diff_y}

        if x<0 or y<0 or x>=map.width or y>=map.height do
          {:halt, map}
        else
          {:cont, CharGrid.update_grid(map, {coords, ?#})}
        end
      end)
      |> then(&Enum.reduce_while(1..1000, &1, fn n, map ->
        {x, y} = coords = {x2 - n*diff_x, y2 - n*diff_y}

        if x<0 or y<0 or x>=map.width or y>=map.height do
          {:halt, map}
        else
          {:cont, CharGrid.update_grid(map, {coords, ?#})}
        end
      end))
      |> CharGrid.update_grid({{x1, y1}, ?#})
      |> CharGrid.update_grid({{x2, y2}, ?#})
    end)
    |> CharGrid.count_chars(?#)
  end

  defp comb(0, _), do: [[]]
  defp comb(_, []), do: []
  defp comb(m, [h|t]) do
    (for l <- comb(m-1, t), do: [h|l]) ++ comb(m, t)
  end
end
