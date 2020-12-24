defmodule AdventOfCode.Day17Test do
  use ExUnit.Case

  import AdventOfCode.Day17

  setup_all do
    [
      input: """
      .#.
      ..#
      ###
      """
    ]
  end

  test "part1", %{input: input} do
    result = part1(input)

    assert result == 112
  end

  test "part2", %{input: input} do
    result = part2(input)

    assert result == 848
  end
end
