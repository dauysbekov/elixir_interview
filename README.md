# Shortcode

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

API Endpoints:

  * `/api/create/?url=[YOUR_URL_HERE]` generates a shortcode url and returns days valid based on open page rank
  * `/api/get/?key=[YOUR_SHORT_CODE]` returns url if it exists and not expired or not_found
