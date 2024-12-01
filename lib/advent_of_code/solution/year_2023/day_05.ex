defmodule AdventOfCode.Solution.Year2023.Day05 do
  def part1(input) do
    [seeds | maps] =
      input
      |> String.split("\n\n", trim: true)

    seeds =
      Regex.run(~r/seeds: ([\d ]+)/, seeds, capture: :all_but_first)
      |> List.first()
      |> String.split()
      |> Enum.map(&String.to_integer/1)

    maps
    |> Enum.map(fn strings ->
      strings
      |> String.split("\n", trim: true)
      |> tl()
      |> Enum.map(fn nums ->
        nums
        |> String.split()
        |> Enum.map(&String.to_integer/1)
      end)
    end)
    |> Enum.reduce(seeds, fn map, state ->
      Enum.map(state, fn datum ->
        Enum.find_value(map, datum, fn [dest, source, length] ->
          if datum >= source && datum < source + length, do: datum + (dest - source), else: false
        end)
      end)
    end)
    |> Enum.min()
  end

  def part2(input) do
    [seeds | maps] =
      input
      |> String.split("\n\n", trim: true)

    maps =
      maps
      |> Enum.map(fn strings ->
        strings
        |> String.split("\n", trim: true)
        |> tl()
        |> Enum.map(fn nums ->
          nums
          |> String.split()
          |> Enum.map(&String.to_integer/1)
        end)
        |> Enum.map(fn [dest, source, length] ->
          {source..(source + length - 1), dest - source}
        end)
        |> Enum.sort()
      end)

    seeds =
      Regex.run(~r/seeds: ([\d ]+)/, seeds, capture: :all_but_first)
      |> List.first()
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2)
      |> Enum.map(fn [start, length] -> start..(start + length) end)
      |> Enum.sort()

    Enum.reduce(maps, seeds, fn map, seeds ->
      move_seeds(seeds, map, [])
    end)
    |> then(fn [min.._ | _] -> min end)
  end

  # no maps left
  defp move_seeds(seeds, [], new_seeds), do: (seeds ++ new_seeds) |> Enum.sort()
  # no seeds left
  defp move_seeds([], _, new_seeds), do: new_seeds |> Enum.sort()

  # first seed range before first map range
  defp move_seeds(
         [_..end_of_seed = first_seed | rest_of_seeds],
         [{first_of_map.._, _} | _] = maps,
         new_seeds
       )
       when end_of_seed < first_of_map do
    move_seeds(rest_of_seeds, maps, [first_seed | new_seeds])
  end

  # first map range before first seed range
  defp move_seeds([start_of_seeds.._ | _] = seeds, [{_..end_of_map, _} | rest_of_maps], new_seeds)
       when end_of_map < start_of_seeds do
    move_seeds(seeds, rest_of_maps, new_seeds)
  end

  # all of first seed in first map
  defp move_seeds(
         [start_of_seed..end_of_seed = seed | rest_of_seeds],
         [{start_of_map..end_of_map, shift} | _] = maps,
         new_seeds
       )
       when start_of_seed >= start_of_map and end_of_seed <= end_of_map do
    move_seeds(rest_of_seeds, maps, [Range.shift(seed, shift) | new_seeds])
  end

  # end of first seed in first map
  defp move_seeds(
         [start_of_seed..end_of_seed | rest_of_seeds],
         [{start_of_map..end_of_map, shift} | _] = maps,
         new_seeds
       )
       when start_of_seed < start_of_map and end_of_seed >= start_of_map and
              end_of_seed <= end_of_map do
    move_seeds(rest_of_seeds, maps, [
      start_of_seed..(start_of_map - 1),
      Range.shift(start_of_map..end_of_seed, shift) | new_seeds
    ])
  end

  # start of first seed is in first map
  defp move_seeds(
         [start_of_seed..end_of_seed | rest_of_seeds],
         [{start_of_map..end_of_map, shift} | rest_of_maps],
         new_seeds
       )
       when start_of_seed >= start_of_map and end_of_seed > end_of_map and
              start_of_seed <= end_of_map do
    move_seeds([(end_of_map + 1)..end_of_seed | rest_of_seeds], rest_of_maps, [
      Range.shift(start_of_seed..end_of_map, shift) | new_seeds
    ])
  end
end
