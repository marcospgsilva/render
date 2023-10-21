defmodule Render.Particles.Particle do
  alias Render.Utils
  alias Render.Table

  @x_limit Table.x_limit()
  @y_limit Table.y_limit()

  defstruct id: :crypto.strong_rand_bytes(8) |> Base.encode64(), direction: :down, x: nil, y: nil

  def new do
    %__MODULE__{
      x: Utils.random(@x_limit),
      y: Utils.random(@y_limit)
    }
  end
end
