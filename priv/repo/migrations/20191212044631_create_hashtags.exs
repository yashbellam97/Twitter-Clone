defmodule Twitter.Repo.Migrations.CreateHashtags do
  use Ecto.Migration

  def change do
    create table(:hashtags) do
      add :hashtag, :string
      add :count, :integer

      timestamps()
    end

  end
end
