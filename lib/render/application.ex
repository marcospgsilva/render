defmodule Render.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      RenderWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Render.PubSub},
      # Start the Endpoint (http/https)
      RenderWeb.Endpoint,
      {PartitionSupervisor, child_spec: DynamicSupervisor, name: Render.Particles.Supervisor}
      # Start a worker by calling: Render.Worker.start_link(arg)
      # {Render.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Render.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RenderWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
