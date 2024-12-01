defmodule AdventOfCode.Solution.Year2023.Day03 do
  alias AdventOfCode.CharGrid

  def part1(input) do
    grid = CharGrid.from_input(input)

    number_cells =
      CharGrid.filter_cells(grid, fn {_coords, contents} ->
        contents in ?0..?9
      end)

    Enum.sort(number_cells, fn {{x1, y1}, _}, {{x2, y2}, _} ->
      y1 < y2 || (y1 == y2 && x1 <= x2)
    end)
    |> Enum.chunk_while(
      [],
      fn {{x, y}, _} = elem, acc ->
        if acc == [] do
          {:cont, [elem]}
        else
          last_cell = List.last(acc)
          {{x0, y0}, _} = last_cell

          if y != y0 || x - x0 != 1 do
            {:cont, acc, [elem]}
          else
            {:cont, acc ++ [elem]}
          end
        end
      end,
      &{:cont, &1, []}
    )
    |> Enum.map(fn number ->
      if Enum.any?(number, fn {coords, _} ->
           CharGrid.adjacent_values(grid, coords)
           |> Enum.any?(fn val ->
             val != ?. && val not in ?0..?9
           end)
         end) do
        Enum.map(number, fn {_, val} -> val end)
      else
        '0'
      end
    end)
    |> Enum.map(&String.to_integer("#{&1}"))
    |> Enum.sum()
  end

  def part2(input) do
    grid = CharGrid.from_input(input)

    gear_cells =
      CharGrid.filter_cells(grid, fn {_coords, contents} ->
        contents == ?*
      end)

    numbers =
      CharGrid.filter_cells(grid, fn {_coords, contents} ->
        contents in ?0..?9
      end)
      |> Enum.sort(fn {{x1, y1}, _}, {{x2, y2}, _} ->
        y1 < y2 || (y1 == y2 && x1 <= x2)
      end)
      |> Enum.chunk_while(
        [],
        fn {{x, y}, _} = elem, acc ->
          if acc == [] do
            {:cont, [elem]}
          else
            last_cell = List.last(acc)
            {{x0, y0}, _} = last_cell

            if y != y0 || x - x0 != 1 do
              {:cont, acc, [elem]}
            else
              {:cont, acc ++ [elem]}
            end
          end
        end,
        &{:cont, &1, []}
      )

    Enum.flat_map(gear_cells, fn {coords, ?*} ->
      neighbours = CharGrid.adjacent_cells(grid, coords)

      adjacent_numbers =
        Enum.filter(numbers, fn number -> Enum.any?(neighbours, &(&1 in number)) end)

      if length(adjacent_numbers) == 2 do
        [
          adjacent_numbers
          |> Enum.map(fn number ->
            String.to_integer("#{Enum.map(number, fn {_, val} -> val end)}")
          end)
          |> Enum.product()
        ]
      else
        []
      end
    end)
    |> Enum.sum()
  end
end
