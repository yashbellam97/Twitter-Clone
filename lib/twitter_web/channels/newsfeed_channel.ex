defmodule TwitterWeb.NewsfeedChannel do
  use TwitterWeb, :channel
  import Ecto.Query

  def join("newsfeed:lobby", payload, socket) do
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
  # broadcast to everyone in the current topic (newsfeed:lobby).
  def handle_in("shout", payload, socket) do
    Twitter.Tweet.changeset(%Twitter.Tweet{}, payload) |> Twitter.Repo.insert

    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  def handle_in("shoutfeed", payload, socket) do
    username = Map.get(payload, "username")
    tweet = Map.get(payload, "tweet")

    tweeter = username
    query = from(follower in Twitter.Follower, where: follower.username == ^username, select: follower.follower)
    result = Twitter.Repo.all(query)
    result = [username | result]
   # IO.inspect result
    Enum.each(result, fn r ->
     # IO.inspect r
      payload = %{username: r, tweeter: tweeter, tweet: tweet}
      Twitter.Feed.changeset(%Twitter.Feed{}, payload) |> Twitter.Repo.insert
      end)
    broadcast socket, "shoutfeed", payload
    {:noreply, socket}
  end

  def handle_in("shouthashtag", payload, socket) do
    IO.inspect payload
    count = Map.get(payload, "count")
    hashtag = Map.get(payload, "hashtag")
    tweet = Map.get(payload, "tweet")
    IO.inspect "Hashtag is #{hashtag}"
    IO.inspect "Count is #{count}"
    IO.inspect "Tweet is #{tweet}"
    # query = from(tag in Twitter.Hashtag, where: tag.hashtag == ^hashtag, select: tag.count)
    # result = Twitter.Repo.all(query)

    # if(result != []) do
    #   from(tag in Twitter.Hashtag, where: tag.hashtag == ^hashtag, update: [set: [count: tag.count + 1]]) |> Twitter.Repo.update_all([])
    # else
    Twitter.Hashtag.changeset(%Twitter.Hashtag{}, payload) |> Twitter.Repo.insert
    # end

    broadcast socket, "shouthashtag", payload
    {:noreply, socket}
  end

  def handle_in("shoutgethashtags", payload, socket) do
    IO.inspect payload
    IO.inspect "SDFSDFSDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"

    Twitter.Hashtag.get_hashtags()
    |> Enum.each(fn t -> push(socket, "shoutgethashtags", %{
      count: t.count,
      hashtag: t.hashtag,
      tweet: t.tweet,
      }) end)

    broadcast socket, "shoutgethashtags", payload
    {:noreply, socket}
  end

  def handle_in("shoutmention", payload, socket) do
    mention = Map.get(payload, "mention")
    tweet = Map.get(payload, "tweet")
    IO.inspect "Mention is #{mention}"
    IO.inspect "Tweet is #{tweet}"

    Twitter.Mention.changeset(%Twitter.Mention{}, payload) |> Twitter.Repo.insert

    broadcast socket, "shoutmention", payload
    {:noreply, socket}
  end

  def handle_in("shoutgetmentions", payload, socket) do
    IO.inspect payload
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    IO.inspect "HOPE THIS ISN'T FIRST"
    Twitter.Tweet.get_tweets()
    |> Enum.each(fn t -> push(socket, "shout", %{
      username: t.username,
      tweet: t.tweet,
      }) end)

    Twitter.Feed.get_feed()
    |> Enum.each(fn t -> push(socket, "shoutfeed", %{
      username: t.username,
      tweet: t.tweet,
      tweeter: t.tweeter
      }) 
      IO.inspect "username is #{t.username}"
      IO.inspect "tweet is #{t.tweet}"
      IO.inspect "tweeter is #{t.tweeter}"
  end)

    Twitter.Mention.get_mentions()
    |> Enum.each(fn t -> push(socket, "shoutgetmentions", %{
      mention: t.mention,
      tweet: t.tweet,
      }) end)

    Twitter.Hashtag.get_hashtags()
    |> Enum.each(fn t -> push(socket, "shouthashtag", %{
      count: t.count,
      hashtag: t.hashtag,
      }) end)
  {:noreply, socket} # :noreply
end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
