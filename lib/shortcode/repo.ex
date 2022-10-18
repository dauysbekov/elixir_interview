defmodule Shortcode.Repo do
  use Ecto.Repo,
    otp_app: :shortcode,
    adapter: Ecto.Adapters.Postgres
end
