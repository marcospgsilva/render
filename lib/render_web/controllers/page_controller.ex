defmodule RenderWeb.PageController do
  use RenderWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
