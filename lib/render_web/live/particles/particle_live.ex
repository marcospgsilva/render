defmodule RenderWeb.ParticleLive do
  use RenderWeb, :live_view

  alias Render.Particles.Supervisor, as: ParticlesSupervisor
  alias IEx.Helpers

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, assign(socket, particles: [], particles_count: 0)}
  end

  @impl Phoenix.LiveView
  def handle_event(
        "new_particles",
        %{"value" => amount},
        socket
      ) do
    ParticlesSupervisor.start(amount)
    schedule()
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event(
        "new_direction",
        %{"value" => direction},
        socket
      ) do
    ParticlesSupervisor.update_direction(String.to_atom(direction))
    schedule()
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("delete", %{"key" => key, "pid" => pid}, socket) do
    DynamicSupervisor.terminate_child(
      GenServer.whereis(
        {:via, PartitionSupervisor, {Render.Particles.Supervisor, String.to_integer(key)}}
      ),
      Helpers.pid(pid)
    )

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_info(:retrieve_particles, socket) do
    particles = ParticlesSupervisor.particles()
    schedule()
    {:noreply, assign(socket, particles: particles, particles_count: Enum.count(particles))}
  end

  def schedule do
    Process.send_after(self(), :retrieve_particles, 60)
  end
end
