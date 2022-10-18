defmodule ShortcodeWeb.ShortcodeController do
  use ShortcodeWeb, :controller

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(conn, %{"url" => url_param}) do
    case valid_url(url_param) do
      true ->
        url = <<"https://openpagerank.com/api/v1.0/getPageRank?domains[]=">> <> url_param
        headers = [{<<"API-OPR">>, <<"ww4oc4c4k4kswcoso4gos8kc0sc8w48ssgcosw0g">>}]
        response = HTTPoison.get!(url, headers)
        decoded = Poison.decode!(response.body)
        [page_rank_resp] = :maps.get(<<"response">>, decoded)
        page_rank_integer = :maps.get(<<"page_rank_integer">>, page_rank_resp)
        page_rank_integer1 = case page_rank_integer > 0 do
          true -> page_rank_integer
          false -> 1
        end

        short_url = random_string()
        short_code_row = %Shortcode.ShortCode{
          id: short_url,
          url: url_param,
          days_valid: page_rank_integer1
        }

        Shortcode.Repo.insert(short_code_row)

        conn
        |> send_resp(
          200,
          Poison.encode!(
            %{
              "shortcode" => short_url,
              "days_valid" => page_rank_integer1
            }
          )
        )
      false ->
        conn |> send_resp(400, "Invalid URL provided")
      end
  end

  @spec get(Plug.Conn.t(), map) :: Plug.Conn.t()
  def get(conn, %{"key" => key_param}) do
    response = case Shortcode.ShortCode |> Shortcode.Repo.get(key_param) do
      nil ->
        "not_found"
      result ->
        created_at = Map.get(result, :inserted_at)
        date_diff = DateTime.diff(DateTime.utc_now(), created_at, :day)
        days_valid = Map.get(result, :days_valid)
        case date_diff > days_valid do
          true -> "not_found"
          false -> Map.get(result, :url)
        end
    end

    conn |> send_resp(200, Poison.encode!(response))
  end

  def random_string() do
    string_length = 8
    :crypto.strong_rand_bytes(string_length)
    |> Base.url_encode64()
    |> binary_part(0, string_length)
  end

  def valid_url(url) do
    uri = URI.parse(url)
    not is_nil(uri.path) and uri.path =~ "."
  end
end
