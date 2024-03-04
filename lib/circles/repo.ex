defmodule Circles.Repo do
  use Ecto.Repo,
    otp_app: :circles,
    adapter: Ecto.Adapters.Postgres
end
