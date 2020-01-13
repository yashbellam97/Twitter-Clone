defmodule Twitter.Feed do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "feeds" do
    field :tweet, :string
    field :tweeter, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(feed, attrs) do
    feed
    |> cast(attrs, [:username, :tweeter, :tweet])
    |> validate_required([:username, :tweeter, :tweet])
  end

  def get_feed() do

    # query = from(tweet in Twitter.Tweet, where: tweet.username == ^uname, select: tweet)
    # result = Twitter.Repo.all(query)
    # result

    Twitter.Repo.all(Twitter.Feed)
  end
end
