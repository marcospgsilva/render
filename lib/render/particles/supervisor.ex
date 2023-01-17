defmodule Render.Particles.Supervisor do
  @moduledoc """
    Responsible for start processes under a DynamicServer in a PartitionSupervisor tree
  """
  use DynamicSupervisor

  alias Render.Particles.ParticleServer
  alias Render.Utils

  def start_link(args) do
    DynamicSupervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    DynamicSupervisor.init(strategy: :one_for_one, max_restarts: 100)
  end

  @doc """
    Starts a list of child under a DynamicSupervisor via PartitionSupervisor
  """
  def start(number_of_particles) do
    amount = String.to_integer(number_of_particles)
    Enum.map(1..amount, fn _ -> start_child() end)
  end

  @doc """
    Starts a child under a DynamicSupervisor via PartitionSupervisor
  """
  def start_child do
    DynamicSupervisor.start_child(
      # Using VIA we can specify the key for each DynamicSupervisor under a PartitionSupervisor.
      {:via, PartitionSupervisor, {__MODULE__, self()}},
      {ParticleServer, []}
    )
  end

  @doc """
    Retrieve the state from each DynamicSupervisor child.
  """
  def particles do
    __MODULE__
    |> DynamicSupervisor.which_children()
    |> Enum.map_reduce([], &find/2)
    |> elem(1)
  end

  def find({key, _pid, _, _}, acc) do
    case DynamicSupervisor.which_children({:via, PartitionSupervisor, {__MODULE__, key}}) do
      [] ->
        {[], acc}

      children ->
        state = Enum.map(children, &retrieve_child(&1, key))
        {state, state}
    end
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

  defp retrieve_child(child, key) do
    child
    |> retrieve_state()
    |> Map.put(:key, key)
  end
end
