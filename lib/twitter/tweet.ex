defmodule Twitter.Tweet do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "tweets" do
    field :tweet, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(tweet, attrs) do
    tweet
    |> cast(attrs, [:username, :tweet])
    |> validate_required([:username, :tweet])
  end

  def get_tweets() do

    # query = from(tweet in Twitter.Tweet, where: tweet.username == ^uname, select: tweet)
    # result = Twitter.Repo.all(query)
    # result

    Twitter.Repo.all(Twitter.Tweet)
  end
end
