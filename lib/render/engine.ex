defmodule Render.Engine do
  alias Render.Table
  alias Render.Utils

  @x_limit Table.x_limit()
  @topic "directions"

  def topic, do: @topic

  def update_direction(particle, new_direction) do
    %{particle | direction: new_direction}
  end

  def update_position(%{direction: direction, y: position_y} = particle)
      when position_y >= 90 and direction in [:down, :right] do
    %{particle | x: Utils.random(@x_limit), y: 5}
  end

  def update_position(%{direction: :down, y: position_y} = particle) do
    %{particle | y: position_y + speed_up()}
  end

  def update_position(%{direction: :right, x: position_x, y: position_y} = particle)
      when position_x >= 95 do
    %{particle | x: 5, y: position_y + speed_up()}
  end

  def update_position(%{direction: :right, x: position_x, y: position_y} = particle) do
    %{particle | x: position_x + speed_up(), y: position_y + speed_up()}
  end

  def update_position(%{x: position_x, y: position_y} = particle)
      when position_y >= 90 and position_x < 5 do
    %{particle | x: 95, y: 5}
  end

  def update_position(%{x: position_x, y: position_y} = particle) when position_y >= 90 do
    %{particle | x: position_x - speed_up(), y: 5}
  end

  def update_position(%{x: position_x, y: position_y} = particle) when position_x <= 5 do
    %{particle | x: 95, y: position_y + speed_up()}
  end

  def update_position(%{x: position_x, y: position_y} = particle) do
    %{particle | x: position_x - speed_up(), y: position_y + speed_up()}
  end

  def speed_up do
    :rand.uniform(3)
  end
end
