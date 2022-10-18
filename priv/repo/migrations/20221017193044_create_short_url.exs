defmodule Shortcode.Repo.Migrations.CreateShortUrl do
  use Ecto.Migration

  def change do
    create table(:short_codes, primary_key: false) do
      add :id, :string, size: 8, primary_key: true
      add :url, :string
      add :days_valid, :integer

      timestamps()
    end

    create unique_index(:short_codes, [:url])
  end
end
