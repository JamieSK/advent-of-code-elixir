defmodule AdventOfCode.Solution.Year2024.Day02 do
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn report ->
      report
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> check_report()
    end)
    |> Enum.count(& &1)
  end

  def part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn report ->
      report = String.split(report, " ", trim: true) |> Enum.map(&String.to_integer/1)

      Enum.reduce(0..length(report), check_report(report), fn i, safe? ->
        safe? || check_report(List.delete_at(report, i))
      end)
    end)
    |> Enum.count(& &1)
  end

  defp check_report(list) do
    {_, safe?, _} = Enum.reduce(list, {nil, nil, nil}, &do_check_report/2)
    safe?
  end

  defp do_check_report(level, {_direction, _safety, _last_num} = params) do
    case params do
      {nil, nil, nil} ->
        {nil, nil, level}

      {nil, nil, last_num} ->
        cond do
          last_num > level && last_num < level + 4 -> {:dec, true, level}
          last_num < level && last_num > level - 4 -> {:inc, true, level}
          true -> {nil, false, level}
        end

      {_, false, _} ->
        params

      {:inc, _, last_num} ->
        cond do
          last_num > level && last_num < level + 4 -> {:inc, false, level}
          last_num < level && last_num > level - 4 -> {:inc, true, level}
          true -> {nil, false, level}
        end

      {:dec, _, last_num} ->
        cond do
          last_num > level && last_num < level + 4 -> {:dec, true, level}
          last_num < level && last_num > level - 4 -> {:dec, false, level}
          true -> {nil, false, level}
        end
    end
  end
end
