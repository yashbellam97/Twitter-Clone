defmodule TwitterWeb.SignupController do
  use TwitterWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end