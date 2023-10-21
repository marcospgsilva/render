defmodule RenderWeb.ParticleLive do
  use RenderWeb, :live_view

  alias Phoenix.PubSub
  alias Render.Engine

  @topic Engine.topic()

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, particles} = Render.particles()
    schedule()

    socket =
      socket
      |> assign(particles_amount: Enum.count(particles))
      |> stream_configure(:particles, dom_id: &"#{&1.id}-#{&1.pid}")
      |> stream(:particles, particles, reset: true)

    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_event(
        "new_particles",
        %{"value" => amount},
        socket
      ) do
    %{particles_amount: particles_amount} = socket.assigns
    current_amount = String.to_integer(amount)
    particles_amount = particles_amount + current_amount

    Render.start_new(amount)

    socket = assign(socket, particles_amount: particles_amount)
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event(
        "new_direction",
        %{"value" => direction},
        socket
      ) do
    broadcast_update_direction(direction)
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("delete", %{"pid" => pid, "id" => id}, socket) do
    %{particles_amount: particles_amount} = socket.assigns
    Render.delete_particle(pid)

    socket =
      socket
      |> stream_delete_by_dom_id(:particles, id)
      |> assign(:particles_amount, particles_amount - 1)

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_info(:retrieve_particles, socket) do
    socket =
      case Render.particles() do
        {:ok, []} ->
          socket

        {:ok, particles} ->
          stream(socket, :particles, particles)
      end

    schedule()
    {:noreply, socket}
  end

  defp broadcast_update_direction(direction) do
    PubSub.broadcast(Render.PubSub, @topic, direction)
  end

  def schedule do
    Process.send_after(self(), :retrieve_particles, 60)
  end
end
