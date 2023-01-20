defmodule RenderWeb.ParticleComponent do
  @moduledoc """
    Render a particle
  """
  use Phoenix.Component

  def particle(assigns) do
    ~H"""
      <div id={@particle.pid} style={"left: #{@particle.x}%; top: #{@particle.y}%;"} phx-click="delete" class="flex flex-1 h-1 w-1 absolute" phx-value-key={@particle.key} phx-value-pid={@particle.pid}>
        <svg width="10" height="60">
            <rect width="10" height="60" style="fill:white" />
        </svg>
      </div>
    """
  end
end
