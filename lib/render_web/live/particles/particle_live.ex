defmodule RenderWeb.ParticleLive do
  use RenderWeb, :live_view

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
    update_direction(direction)
    schedule()
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("delete", %{"key" => key, "pid" => pid}, socket) do
    Render.delete_particle(pid, key)
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_info(:retrieve_particles, socket) do
    with {:ok, particles} <- Render.particles() do
      schedule()
      {:noreply, assign(socket, particles: particles, particles_count: Enum.count(particles))}
    end
  end

  defp update_direction(direction) do
    direction
    |> String.to_atom()
    |> Render.update_direction()
  end

  def schedule do
    Process.send_after(self(), :retrieve_particles, 60)
  end
end
