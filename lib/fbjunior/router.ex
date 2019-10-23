# Для веб сервера нужен маршрутизатор, место ему именно тут.
defmodule Router do
  use Plug.Router
  require Logger

  plug Plug.Parsers,
    parsers: [:json],
    pass: ["*/*"],
    json_decoder: Jason

  plug Plug.SetContentType
  plug(:match)
  plug(:dispatch)


  # Submit links
  post "/visited_links" do
    {status, body} = case conn.body_params do
      %{"links" => links} when is_list(links) ->
        now = Utils.timestamp()
        domains = for link <- links do
                    {:ok, domain} = Utils.domain(link)
                    String.downcase(to_string(domain))
                  end
        status = Utils.set_domains(domains, now)
        {201, %{status: status}}
      _ ->
        {400, %{status: "Bad Request"}}
    end
    send_resp(conn, status, Jason.encode!(body))
  end

  # Get unique domains
  get "/visited_domains" do
    {status, body} = case conn.query_params do
      %{"from" => from0, "to" => to0} ->
        {from, _} = Integer.parse(from0)
        {to, _} = Integer.parse(to0)
        body = case Utils.get_domains(from, to) do
                domains when is_list(domains) -> %{domains: domains, status: "ok"}
                _ -> %{domains: [], status: "redis error"}
        end
        {200, body}
      _ ->
        {400, %{status: "Bad Request"}}
      end
      send_resp(conn, status, Jason.encode!(body))
  end

  # Catch-up
  match _ do
    send_resp(conn, 404, Jason.encode!(%{status: "Not found"}))
  end
end

