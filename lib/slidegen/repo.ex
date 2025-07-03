defmodule Slidegen.Repo do
  use Ecto.Repo,
    otp_app: :slidegen,
    adapter: Ecto.Adapters.Postgres
end
