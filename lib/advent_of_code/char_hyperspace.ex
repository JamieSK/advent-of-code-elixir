defmodule AdventOfCode.CharHyperspace do
  @moduledoc "Data structure representing an infinite 4D grid of characters by a map of {x, y, z, w} => char"

  alias __MODULE__, as: T

  @type t :: %T{
          grid: grid,
          empty_char: char
        }

  @typep grid :: %{coordinates => char}

  @type coordinates :: {integer, integer, integer, integer}

  defstruct ~w[grid empty_char]a

  # List of coords that produce the 26 coordinates surrounding a given coord when added to it
  @adjacent_deltas for x <- -1..1,
                       y <- -1..1,
                       z <- -1..1,
                       w <- -1..1,
                       not (x == 0 and y == 0 and z == 0 and w == 0),
                       do: {x, y, z, w}

  @spec from_input(String.t(), char) :: t()
  def from_input(input, empty_char \\ ?.) do
    charlists =
      input
      |> String.split()
      |> Enum.map(&String.to_charlist/1)

    grid =
      for {line, y} <- Enum.with_index(charlists),
          {char, x} <- Enum.with_index(line),
          into: %{},
          do: {{x, y, 0, 0}, char}

    update(%T{empty_char: empty_char}, grid)
  end

  @doc "Gets the value at the given coordinates."
  @spec at(t(), coordinates) :: char
  def at(%T{} = t, coords) do
    Map.get(t.grid, coords, t.empty_char)
  end

  @doc "Applies `fun` to each cell in the CharHyperspace to produce a new CharHyperspace."
  @spec map(t(), ({coordinates, char} -> char)) :: t()
  def map(%T{} = t, fun) do
    grid = for({coords, _} = entry <- t.grid, into: %{}, do: {coords, fun.(entry)})

    update(t, grid)
  end

  @doc """
  Returns the number of cells in the CharHyperspace for which `fun` returns a truthy value.
  Counting the number of empty cells is not supported.
  """
  @spec count(t(), ({coordinates, char} -> as_boolean(term))) :: non_neg_integer()
  def count(%T{} = t, fun) do
    Enum.count(t.grid, fun)
  end

  @doc """
  Returns the number of cells in the CharHyperspace containing `char`.
  This returns `:infinity` when passed the CharHyperspace's empty char.
  """
  @spec count_chars(t(), char) :: non_neg_integer() | :infinity
  def count_chars(%T{} = t, char) do
    case t.empty_char do
      ^char -> :infinity
      _ -> count(t, fn {_, c} -> c == char end)
    end
  end

  @doc "Returns a list of values from the 26 cells adjacent to the one at `coords`."
  @spec adjacent_values(t(), coordinates) :: list(char)
  def adjacent_values(%T{} = t, coords) do
    @adjacent_deltas
    |> Enum.map(&sum_coordinates(coords, &1))
    |> Enum.map(&at(t, &1))
  end

  defp update(t, grid) do
    bounds = get_bounds(grid, t.empty_char)

    %{t | grid: fill(grid, bounds, t.empty_char)}
  end

  defp get_bounds(grid, empty_char) do
    [{x, y, z, w} | nonempties] = nonempty_coords(grid, empty_char)
    acc = {x..x, y..y, z..z, w..w}

    nonempties
    |> Enum.reduce(acc, &min_maxer/2)
    |> Tuple.to_list()
    |> Enum.map(&pad_range/1)
    |> List.to_tuple()
  end

  defp nonempty_coords(grid, empty_char) do
    for {coords, value} <- grid, not match?(^empty_char, value), do: coords
  end

  defp min_maxer({x, y, z, w}, {xmin..xmax, ymin..ymax, zmin..zmax, wmin..wmax}) do
    {min(x, xmin)..max(x, xmax), min(y, ymin)..max(y, ymax), min(z, zmin)..max(z, zmax),
     min(w, wmin)..max(w, wmax)}
  end

  defp fill(grid, {x_bounds, y_bounds, z_bounds, w_bounds}, empty_char) do
    all_coords = for x <- x_bounds, y <- y_bounds, z <- z_bounds, w <- w_bounds, do: {x, y, z, w}

    Enum.reduce(all_coords, grid, fn coords, g -> Map.put_new(g, coords, empty_char) end)
  end

  defp sum_coordinates({x1, y1, z1, w1}, {x2, y2, z2, w2}),
    do: {x1 + x2, y1 + y2, z1 + z2, w1 + w2}

  defp pad_range(l..r), do: (l - 1)..(r + 1)
end
