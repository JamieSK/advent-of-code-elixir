defmodule AdventOfCode.Solution.Year2024.Day09 do
  def part1(input) do
    input
    |> String.trim()
    |> String.split("", trim: true)
    |> then(&if rem(length(&1), 2) == 0, do: Enum.slice(&1, 0..-2), else: &1)
    |> Enum.map(&String.to_integer/1)
    |> shift_and_checksum(0, 0, 0)
  end

  def part2(input) do
    input
    |> String.trim()
    |> String.split("", trim: true)
    |> then(&if rem(length(&1), 2) == 0, do: &1, else: &1 ++ ["0"])
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.with_index()
    |> Enum.flat_map(fn {[file, space], id} -> [List.duplicate(id, file), List.duplicate(nil, space)] end)
    |> shift_lists()
    |> Enum.concat()
    |> checksum(0, 0)
  end

  defp checksum(list, index, total) when index >= length(list), do: total
  defp checksum(list, index, total), do: checksum(list, index + 1, total + index * (Enum.at(list, index) || 0))
  
  defp shift_lists(list), do: shift_lists(list, length(list) - 1)

  defp shift_lists(list, index) do
    case Enum.at(list, index) do
      nil -> list
      [] -> shift_lists(list, index-1)
      [nil | _] -> shift_lists(list, index-1)
      num_list ->
        filesize = length(num_list)
        new_list = case Enum.find_index(list, fn space -> space != [] && hd(space) == nil && length(space) >= filesize end) do
          nil -> list
          space_index when space_index < index ->
            space_length = list |> Enum.at(space_index) |> length()
            list
            |> List.replace_at(space_index, num_list)
            |> List.replace_at(index, List.duplicate(nil, filesize))
            |> then(&if space_length > filesize, do: List.insert_at(&1, space_index+1, List.duplicate(nil, space_length-filesize)), else: &1)
          _ -> list
        end
        shift_lists(new_list, index-1)
    end
  end

  defp shift_and_checksum(list, compressed_index, _index, total) when compressed_index >= length(list), do: total

  defp shift_and_checksum(list, compressed_index, index, total) when rem(compressed_index, 2) == 0 do
    char = Enum.at(list, compressed_index)

    new_total = Enum.reduce(index..(index+char-1), total, fn i, t -> i*div(compressed_index, 2) + t end)

    shift_and_checksum(list, compressed_index + 1, index + char, new_total)
  end

  defp shift_and_checksum(list, compressed_index, index, total) do
    {new_list, new_index, new_total} = case Enum.at(list, compressed_index) do
      0 -> {list, index, total}
      c ->
        Enum.reduce(1..c, {list, index, total}, fn _, {l, i, t} ->
          if Enum.sum(l) < i do
            {l, i, t}
          else
            case List.last(l) do
              1 -> {Enum.slice(l, 0..-3), i+1, t+(div(length(l), 2)*i)}
              x -> {List.replace_at(l, -1, x-1), i+1, t+(div(length(l), 2)*i)}
            end
          end
        end)
    end

    shift_and_checksum(new_list, compressed_index + 1, new_index, new_total)
  end
end
