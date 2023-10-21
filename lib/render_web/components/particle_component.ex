defmodule RenderWeb.ParticleComponent do
  @moduledoc """
    Render a particle
  """
  use Phoenix.Component

  def particle(assigns) do
    ~H"""
    <div
      id={@particle.pid}
      style={"left: #{@particle.x}%; top: #{@particle.y}%;"}
      phx-click="delete"
      class="flex flex-1 h-1 w-1 absolute"
      phx-value-pid={@particle.pid}
      phx-value-id={@particle.id}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
