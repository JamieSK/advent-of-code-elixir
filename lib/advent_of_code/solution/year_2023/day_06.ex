defmodule AdventOfCode.Solution.Year2023.Day06 do
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      Regex.run(~r/[a-zA-Z: ]+([\d ]+)/, line, capture: :all_but_first)
      |> hd()
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.zip()
    |> Enum.map(fn {time, distance} ->
      {upper_bound, lower_bound} = quadratic(1, -time, distance + 0.000001)
      lower_integer = floor(lower_bound) + 1
      upper_integer = floor(upper_bound)

      upper_integer - lower_integer + 1
    end)
    |> Enum.product()
  end

  def part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      Regex.run(~r/[a-zA-Z: ]+([\d ]+)/, line, capture: :all_but_first)
      |> hd()
      |> String.split()
      |> Enum.join("")
      |> String.to_integer()
    end)
    |> then(fn [time, distance] ->
      {upper_bound, lower_bound} = quadratic(1, -time, distance + 0.000001)
      lower_integer = floor(lower_bound) + 1
      upper_integer = floor(upper_bound)

      upper_integer - lower_integer + 1
    end)
  end

  defp quadratic(a, b, c) do
    {
      (-b + :math.sqrt(b ** 2 - 4 * a * c)) / (2 * a),
      (-b - :math.sqrt(b ** 2 - 4 * a * c)) / (2 * a)
    }
  end
end

# t = total time
# d = distance
# r = record distance
# h = hold time

# d = h*(t-h)
#   = th-h^2

# if (th-h^2) == r
#   h^2 - th + r = 0

#   a=1
#   b=t
#   c=r

#   -t±√(t^2-4r)/2
