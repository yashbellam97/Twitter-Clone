defmodule TwitterWeb.FollowChannel do
  use TwitterWeb, :channel
  import Ecto.Query

  def join("follow:lobby", payload, socket) do
    if authorized?(payload) do
      send(self(), :after_join)
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
  # broadcast to everyone in the current topic (follow:lobby).
  def handle_in("shout", payload, socket) do
    IO.inspect payload
    
    follower = Map.get(payload, "username")
    username = Map.get(payload, "userToFollow")
    IO.inspect "Name is #{follower}"
    IO.inspect "User to follow is #{username}"

    Twitter.Follower.changeset(%Twitter.Follower{}, payload) |> Twitter.Repo.insert

    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  def handle_in("shout2", payload, socket) do
    IO.inspect payload

    Twitter.Following.changeset(%Twitter.Following{}, payload) |> Twitter.Repo.insert

    broadcast socket, "shout2", payload
    {:noreply, socket}
  end

  def handle_in("shoutgetfollowers", payload, socket) do
    IO.inspect payload
    {:noreply, socket}
  end

  def handle_in("shoutgetfollowing", payload, socket) do
    IO.inspect payload
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    Twitter.Follower.get_followers()
    |> Enum.each(fn f -> push(socket, "shoutgetfollowers", %{
      username: f.username,
      follower: f.follower
      }) end)

    IO.inspect Twitter.Following.get_following()
    |> Enum.each(fn f -> push(socket, "shoutgetfollowing", %{
      username: f.username,
      following: f.following
      }) end)
  {:noreply, socket} # :noreply
end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
