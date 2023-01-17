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
end
