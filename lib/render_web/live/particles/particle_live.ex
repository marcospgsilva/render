defmodule RenderWeb.ParticleLive do
  use RenderWeb, :live_view

  alias Phoenix.PubSub
  alias Render.Engine

  @topic Engine.topic()

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, particles} = Render.particles()
    schedule()
    {:ok, assign(socket, particles: particles, particles_count: Enum.count(particles))}
  end

  @impl Phoenix.LiveView
  def handle_event(
        "new_particles",
        %{"value" => amount},
        socket
      ) do
    Render.start_new(amount)
    schedule()
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event(
        "new_direction",
        %{"value" => direction},
        socket
      ) do
    broadcast_update_direction(direction)
    schedule()
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("delete", %{"pid" => pid}, socket) do
    Render.delete_particle(pid)
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_info(:retrieve_particles, socket) do
    with {:ok, particles} <- Render.particles() do
      schedule()
      {:noreply, assign(socket, particles: particles, particles_count: Enum.count(particles))}
    end
  end

  defp broadcast_update_direction(direction) do
    PubSub.broadcast(Render.PubSub, @topic, direction)
  end

  def schedule do
    Process.send_after(self(), :retrieve_particles, 60)
  end
end
