defmodule Render.Particles.ParticleServer do
  @moduledoc """
    Each particle is a GenServer in loop, updating its state with a new position
  """
  use GenServer

  alias Render.Engine
  alias Render.Particles.Particle

  @interval 60

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, Particle.new())
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
  def handle_cast({:update_direction, new_direction}, particle) do
    particle = Engine.update_direction(particle, new_direction)
    {:noreply, particle}
  end

  @impl true
  def handle_info(:update, position) do
    particle = Engine.update_position(position)
    schedule()
    {:noreply, particle}
  end

  def schedule do
    Process.send_after(self(), :update, @interval)
  end
end
