defmodule Twitter.Repo.Migrations.CreateFeeds do
  use Ecto.Migration

  def change do
    create table(:feeds) do
      add :username, :string
      add :tweeter, :string
      add :tweet, :string

      timestamps()
    end

  end
end
