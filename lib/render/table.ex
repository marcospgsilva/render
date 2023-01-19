defmodule Render.Table do
  def x_limit, do: Application.fetch_env!(:render, :table)[:x]
  def y_limit, do: Application.fetch_env!(:render, :table)[:y]
end
