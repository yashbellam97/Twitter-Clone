defmodule Twitter.Repo.Migrations.CreateFollowing do
  use Ecto.Migration

  def change do
    create table(:following) do
      add :username, :string
      add :following, :string

      timestamps()
    end

  end
end
