defmodule Twitter.Following do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "following" do
    field :following, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(following, attrs) do
    following
    |> cast(attrs, [:username, :following])
    |> validate_required([:username, :following])
  end

    def get_following() do

      # query = from(user in Twitter.Follower, where: user.username == ^uname, select: user.follower)
      # result = Twitter.Repo.all(query)
      # IO.inspect result
      # result

      Twitter.Repo.all(Twitter.Following)
    end
end
