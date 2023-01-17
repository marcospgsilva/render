defmodule Render.Particles.ParticleServer do
  @moduledoc """
    Each particle is a GenServer in loop, updating its state with a new position
  """
  use GenServer

  @limit 90
  @interval 60
  @velocity 2

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{x: random(), y: random()})
  end

  def get_state(pid) do
    GenServer.call(pid, :get_state)
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
  def handle_info(:update, position) do
    schedule()
    {:noreply, generate_position(position)}
  end

  def schedule do
    Process.send_after(self(), :update, @interval)
  end

  defp generate_position(position) do
    %{
      x: change_horizontally(position),
      y: sum(position)
    }
  end

  def change_horizontally(%{y: position_y}) when position_y >= 90, do: random()
  def change_horizontally(%{x: position_x}), do: position_x

  def sum(%{y: position_y}) when position_y >= 90, do: 5
  def sum(%{y: position_y}), do: position_y + @velocity

  defp random do
    :rand.uniform(@limit)
  end
end
