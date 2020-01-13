defmodule Twitter.Repo.Migrations.CreateTweets do
  use Ecto.Migration

  def change do
    create table(:tweets) do
      add :username, :string
      add :tweet, :string

      timestamps()
    end

  end
end
