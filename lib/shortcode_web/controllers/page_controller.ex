defmodule ShortcodeWeb.PageController do
  use ShortcodeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
