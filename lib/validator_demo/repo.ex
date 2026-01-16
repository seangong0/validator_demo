defmodule ValidatorDemo.Repo do
  use Ecto.Repo,
    otp_app: :validator_demo,
    adapter: Ecto.Adapters.SQLite3
end
