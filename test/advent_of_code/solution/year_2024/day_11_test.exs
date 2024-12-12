defmodule AdventOfCode.Solution.Year2024.Day11Test do
  use ExUnit.Case, async: true

  import AdventOfCode.Solution.Year2024.Day11

  setup do
    [
      input: """
      125 17
      """
    ]
  end

  test "part1", %{input: input} do
    result = part1(input)

    assert result == 55312
  end

  test "part2", %{input: input} do
    result = part2(input)

    assert result == 55312
  end
end
