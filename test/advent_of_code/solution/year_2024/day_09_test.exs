defmodule AdventOfCode.Solution.Year2024.Day09Test do
  use ExUnit.Case, async: true

  import AdventOfCode.Solution.Year2024.Day09

  setup do
    [
      input: """
      2333133121414131402
      """
    ]
  end

  describe "part1" do
    test "1" do
      assert part1("2333133121414131402") == 1928
    end

    test "2" do
      assert part1("12345") == 60
    end

    test "3" do
      assert part1("1010101010101010101010") == 385
    end

    test "4" do
      assert part1("252") == 5
    end

    test "5" do
      assert part1("354631466260") == 1003
    end
  end

  test "part2", %{input: input} do
    result = part2(input)

    assert result == 2858
  end

  test "2" do
    assert part2("252") == 5
  end
end
