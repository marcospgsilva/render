defmodule Render.Particles.Supervisor do
  @moduledoc """
    Responsible for start processes under a DynamicServer in a PartitionSupervisor tree
  """
  use DynamicSupervisor

  alias IEx.Helpers
  alias Render.Particles.ParticleServer
  alias Render.Utils

  def start_link(args) do
    DynamicSupervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @doc """
    Terminate a DynamicSupervisor child
  """
  def delete_particle(pid) do
    DynamicSupervisor.terminate_child(
      GenServer.whereis({:via, PartitionSupervisor, {__MODULE__, self()}}),
      Helpers.pid(pid)
    )
  end

  def init(_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  @doc """
    Starts a list of child under a DynamicSupervisor via PartitionSupervisor
  """
  def start_new(number_of_particles) do
    amount = String.to_integer(number_of_particles)
    children = Enum.map(1..amount, fn _ -> start_child() end)
    {:ok, children}
  end

  @doc """
    Starts a child under a DynamicSupervisor via PartitionSupervisor
  """
  def start_child do
    # Using VIA we can specify the key for each DynamicSupervisor under a PartitionSupervisor.
    {:via, PartitionSupervisor, {__MODULE__, self()}}
    |> DynamicSupervisor.start_child({Render.Particles.ParticleServer, []})
    |> elem(1)
  end

  @doc """
    Retrieve the state from each DynamicSupervisor child.
  """
  def particles do
    particles =
      __MODULE__
      |> DynamicSupervisor.which_children()
      |> Enum.reduce([], &retrieve_dynamic_supervisors/2)

    {:ok, particles}
  end

  def retrieve_dynamic_supervisors({key, _pid, _, _}, acc) do
    case DynamicSupervisor.which_children({:via, PartitionSupervisor, {__MODULE__, key}}) do
      [] ->
        acc

      children ->
        children
        |> Enum.map(&retrieve_child/1)
        |> Enum.concat(acc)
    end
  end

  defp retrieve_child(child) do
    retrieve_state(child)
  end

  defp retrieve_state({_, pid, _, _}) do
    do_retrieve_state(pid)
  end

  defp retrieve_state(pid) do
    do_retrieve_state(pid)
  end

  defp do_retrieve_state(pid) do
    pid
    |> ParticleServer.get_state()
    |> Map.put(:pid, Utils.format_pid(pid))
  end
end
