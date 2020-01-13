defmodule Twitter.Mention do
  use Ecto.Schema
  import Ecto.Changeset

  schema "mentions" do
    field :mention, :string
    field :tweet, :string

    timestamps()
  end

  @doc false
  def changeset(mention, attrs) do
    mention
    |> cast(attrs, [:mention, :tweet])
    |> validate_required([:mention, :tweet])
  end

  def get_mentions() do

    # query = from(user in Twitter.Follower, where: user.username == ^uname, select: user.follower)
    # result = Twitter.Repo.all(query)
    # IO.inspect result
    # result

    Twitter.Repo.all(Twitter.Mention)
  end
end
