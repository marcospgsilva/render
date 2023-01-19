defmodule Render.Utils do
  @moduledoc """
    Just utils functions.
  """
  def format_pid(pid) do
    pid
    |> inspect()
    |> String.replace("#PID<", "")
    |> String.replace(">", "")
  end

  def random(limit) do
    :rand.uniform(limit)
  end
end
