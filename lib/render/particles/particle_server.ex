defmodule Render.Particles.ParticleServer do
  @moduledoc """
    Each particle is a GenServer in loop, updating its state with a new position
  """
  use GenServer

  alias Render.Engine
  alias Render.Particles.Particle
  alias Phoenix.PubSub

  @interval 60
  @topic Engine.topic()

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, Particle.new())
  end

  def get_state(pid) do
    GenServer.call(pid, :get_state)
  end

  @impl true
  def init(initial_state) do
    PubSub.subscribe(Render.PubSub, @topic)
    schedule()
    {:ok, initial_state}
  end

  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_info(:update, particle) do
    particle = Engine.update_position(particle)
    schedule()
    {:noreply, particle}
  end

  @impl true
  def handle_info(new_direction, particle) do
    particle = Engine.update_direction(particle, String.to_atom(new_direction))
    {:noreply, particle}
  end

  def schedule do
    Process.send_after(self(), :update, @interval)
  end
end
