defmodule Render.Particles.ParticleServer do
  @moduledoc """
    Each particle is a GenServer in loop, updating its state with a new position
  """
  use GenServer

  @x_limit 99
  @y_limit 90
  @interval 60

  @initial_direction :down

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{
      direction: @initial_direction,
      x: random(:x),
      y: random(:y)
    })
  end

  def get_state(pid) do
    GenServer.call(pid, :get_state)
  end

  def update_direction(pid, new_direction) do
    GenServer.cast(pid, {:update_direction, new_direction})
  end

  @impl true
  def init(initial_state) do
    schedule()
    {:ok, initial_state}
  end

  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast({:update_direction, new_direction}, state) do
    {:noreply, %{state | direction: new_direction}}
  end

  @impl true
  def handle_info(:update, position) do
    schedule()
    {:noreply, generate_position(position)}
  end

  def schedule do
    Process.send_after(self(), :update, @interval)
  end

  defp generate_position(position) do
    %{position | x: change_horizontally(position), y: sum(position)}
  end

  def change_horizontally(%{y: position_y}) when position_y >= 90,
    do: random(:x)

  def change_horizontally(%{x: position_x, direction: :down}), do: position_x

  def change_horizontally(%{x: position_x, direction: :right}) when position_x >= 95,
    do: random(:x)

  def change_horizontally(%{x: position_x, direction: :right}), do: position_x + velocity()

  def change_horizontally(%{x: position_x, direction: :left}) when position_x <= 5,
    do: random(:x)

  def change_horizontally(%{x: position_x, direction: :left}), do: position_x - velocity()

  def sum(%{y: position_y}) when position_y >= 90, do: 5
  def sum(%{y: position_y}), do: position_y + velocity()

  def velocity do
    :rand.uniform(3)
  end

  defp random(axis) do
    case axis do
      :x ->
        :rand.uniform(@x_limit)

      _ ->
        :rand.uniform(@y_limit)
    end
  end
end
