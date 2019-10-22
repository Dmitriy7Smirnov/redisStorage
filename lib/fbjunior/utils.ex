defmodule Utils do
  @keys "keys" #sorted set name

  def timestamp do
    :os.system_time(:seconds)
  end

  def domain(link) do
    case URI.parse(link) do
      %URI{authority: domain} when is_binary(domain) -> {:ok, domain}
      _ ->
        case URI.parse("http://" <> link) do
          %URI{authority: domain} when is_binary(domain) -> {:ok, domain}
          _ -> nil
        end
    end
  end

  def set_domains(domains, time) do
    commands =[
      ["SADD", to_string(time) | domains],
      ["ZADD", @keys, time, to_string(time)]
    ]
    case Redix.pipeline(:redix, commands) do
      {:ok, _} -> "ok"
            _  -> "redis error"
    end
  end

  def get_domains(from, to) do
    with  {:ok, keys} <- Redix.command(:redix, ["ZRANGEBYSCORE", @keys, from, to]),
       {:ok, domains} <- Redix.command(:redix, ["SUNION" | keys]) do
       domains
    end
  end

end
