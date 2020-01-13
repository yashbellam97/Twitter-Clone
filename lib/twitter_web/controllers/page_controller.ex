defmodule TwitterWeb.PageController do
  use TwitterWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def login(conn, %{"user" => user}) do
  	render(conn, "login.html", user: user)
  end
end
