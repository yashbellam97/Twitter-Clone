defmodule Twitter.Repo.Migrations.CreateMentions do
  use Ecto.Migration

  def change do
    create table(:mentions) do
      add :mention, :string
      add :tweet, :string

      timestamps()
    end

  end
end
