defmodule Twitter.Repo.Migrations.CreateFollowers do
  use Ecto.Migration

  def change do
    create table(:followers) do
      add :username, :string
      add :follower, :string

      timestamps()
    end

  end
end
