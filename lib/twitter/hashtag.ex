defmodule Twitter.Hashtag do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "hashtags" do
    field :hashtag, :string
    field :count, :integer
    field :tweet, :string
    timestamps()
  end

  @doc false
  def changeset(hashtag, attrs) do
    hashtag
    |> cast(attrs, [:hashtag, :count, :tweet])
    |> validate_required([:hashtag, :count, :tweet])
  end

  def get_hashtags() do
    Twitter.Repo.all(Twitter.Hashtag)
  end

end
