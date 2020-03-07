defmodule ReadableOrphans.Using do
  defmacro __using__(_) do
    quote location: :keep do
      import Read
      require Algae.Either.Left, as: Left
      require Algae.Either.Right, as: Right
      require Witchcraft.Unit, as: Unit
      require ReadableOrphans.Either, as: Either
    end
  end
end
