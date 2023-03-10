defmodule Render do
  @moduledoc """
  Render keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  defdelegate start_new(particles_amount), to: Render.Particles.Supervisor
  defdelegate particles(), to: Render.Particles.Supervisor
  defdelegate delete_particle(pid), to: Render.Particles.Supervisor
end
