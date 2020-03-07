defmodule ReadableOrphans do
  @moduledoc """
  Orphan instances of Readable type class. Use at your own risk.

  ## Examples

  ```
  iex> use ReadableOrphans
  iex> read(:error, Either)
  %Algae.Either.Left{left: %Witchcraft.Unit{}}
  iex> read(true, Either)
  %Algae.Either.Right{right: %Witchcraft.Unit{}}
  iex> read(:banana, Either)
  ** (Readable.Exception) ReadableOrphans.Either can not be read from :banana

  iex> use ReadableOrphans
  iex> read({:error, "hello"}, Either)
  %Algae.Either.Left{left: "hello"}
  iex> read({:ok, "world"}, Either)
  %Algae.Either.Right{right: "world"}
  iex> read({:foo, "bar"}, Either)
  ** (Readable.Exception) ReadableOrphans.Either can not be read from {:foo, "bar"}
  ```
  """
  defmacro __using__(_) do
    quote location: :keep do
      use ReadableOrphans.Using
    end
  end

  use ReadableOrphans.Using

  defreadable Either, from: x :: Atom do
    cond do
      x in [:error, false, nil, :undefined] -> Left.new(%Unit{})
      x in [:ok, true] -> Right.new(%Unit{})
      true -> fail!(x)
    end
  end

  defreadable Atom, from: _ :: Left do
    :error
  end

  defreadable Atom, from: _ :: Right do
    :ok
  end

  defreadable Either, from: x :: Tuple do
    case x do
      {:error, y} -> %Left{left: y}
      {:ok, y} -> %Right{right: y}
      _ -> fail!(x)
    end
  end

  defreadable Tuple, from: %Left{left: x} :: Left do
    {:error, x}
  end

  defreadable Tuple, from: %Right{right: x} :: Right do
    {:ok, x}
  end
end
