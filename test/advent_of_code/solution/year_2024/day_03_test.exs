defmodule AdventOfCode.Solution.Year2024.Day03Test do
  use ExUnit.Case, async: true

  import AdventOfCode.Solution.Year2024.Day03

  setup do
    [
      input: """
      xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
      """,
      input_2: """
      xmul(2,4)&mul[3,7]!^don't()_mul(5,5)don't()+mul(32,64]
      (mul(11,8)undo()?mul(8,5)don't()mul(10,10))do()
      """
    ]
  end

  test "part1", %{input: input} do
    result = part1(input)

    assert result == 161
  end

  test "part2", %{input_2: input} do
    result = part2(input)

    assert result == 48
  end
end
