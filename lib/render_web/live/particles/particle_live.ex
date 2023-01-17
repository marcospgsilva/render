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
    with {:ok, _children} <- Render.start_new(amount) do
      schedule()
      {:noreply, socket}
    end
  end

  @impl Phoenix.LiveView
  def handle_event(
        "new_direction",
        %{"value" => direction},
        socket
      ) do
    direction
    |> String.to_atom()
    |> Render.update_direction()

    schedule()
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("delete", %{"key" => key, "pid" => pid}, socket) do
    DynamicSupervisor.terminate_child(
      GenServer.whereis(
        {:via, PartitionSupervisor, {ParticlesSupervisor, String.to_integer(key)}}
      ),
      Helpers.pid(pid)
    )

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_info(:retrieve_particles, socket) do
    with {:ok, particles} <- Render.particles() do
      schedule()
      {:noreply, assign(socket, particles: particles, particles_count: Enum.count(particles))}
    end
  end

  def schedule do
    Process.send_after(self(), :retrieve_particles, 60)
  end
end
