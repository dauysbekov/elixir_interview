defmodule Shortcode.ShortCode do
  use Ecto.Schema
  @timestamps_opts [type: :utc_datetime]

  @primary_key {:id, :string, []}
  schema "short_codes" do
    field :url, :string
    field :days_valid, :integer

    timestamps()
  end
end
