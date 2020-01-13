defmodule TwitterWeb.RoomChannel do
  use TwitterWeb, :channel

  import Ecto.Query

  def join("room:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  def handle_in("shout", payload, socket) do
    username = Map.get(payload, "username")
    password = Map.get(payload, "password")
    IO.inspect "Name is #{username}"
    IO.inspect "Password is #{password}"
    query = from(user in Twitter.User, where: user.username == ^username, select: user.password)

    result = Twitter.Repo.all(query)
    IO.inspect result

    if(result == []) do
      IO.inspect "USER DOESN'T EXIST"
      broadcast socket, "shout", payload
      {:reply, :noexist, socket}
    else
      if([password] == result) do
        IO.inspect "YOU CAN LOGIN"
        broadcast socket, "shout", payload
        {:reply, :ok, socket}
      else 
        IO.inspect "INCORRECT PASSWORD"
        broadcast socket, "shout", payload
        {:reply, :incorrect, socket}
    end
  end
end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

end
