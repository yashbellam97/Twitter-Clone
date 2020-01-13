defmodule Twitter.Follower do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "followers" do
    field :follower, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(follower, attrs) do
    follower
    |> cast(attrs, [:username, :follower])
    |> validate_required([:username, :follower])
  end

  def get_followers() do

    # query = from(user in Twitter.Follower, where: user.username == ^uname, select: user.follower)
    # result = Twitter.Repo.all(query)
    # IO.inspect result
    # result

    Twitter.Repo.all(Twitter.Follower)
  end

end
