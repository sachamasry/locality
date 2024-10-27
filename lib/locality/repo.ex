defmodule Locality.Repo do
  use Ecto.Repo,
    otp_app: :locality,
    adapter: Ecto.Adapters.SQLite3
end
