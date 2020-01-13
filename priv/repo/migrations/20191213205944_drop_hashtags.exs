defmodule Twitter.Repo.Migrations.DropHashtags do
  use Ecto.Migration

  def change do
  	alter table("hashtags") do
  		add_if_not_exists :tweet, :string
	end
  end
end
