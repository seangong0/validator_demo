defmodule ValidatorDemo.Schema do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
      @timestamps_opts [type: :utc_datetime_usec]

      import Ecto.Query
      import Ecto.Changeset
    end
  end
end
