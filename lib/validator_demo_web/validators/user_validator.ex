defmodule ValidatorDemoWeb.Validators.UserValidator do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :email, :string
    field :password, :string
    field :nickname, :string
  end

  def validate_create(params) do
    %__MODULE__{}
    |> cast(params, [:email, :password, :nickname])
    |> validate_required([:email, :password, :nickname])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must be a valid email")
    |> validate_length(:password, min: 6)
    |> validate_length(:nickname, min: 2, max: 50)
    |> handle_changeset(:insert)
  end

  def validate_update(params) do
    %__MODULE__{}
    |> cast(params, [:password, :nickname])
    |> validate_length(:password, min: 6)
    |> validate_length(:nickname, min: 2, max: 50)
    |> handle_changeset(:update)
  end

  def validate_uuid(id) when is_binary(id) do
    case Ecto.Type.cast(Ecto.UUID, id) do
      {:ok, _} -> :ok
      :error -> {:error, "invalid UUID format"}
    end
  end

  def validate_uuid(_id), do: {:error, "id must be a UUID"}

  defp handle_changeset(changeset, action) do
    case apply_action(changeset, action) do
      {:ok, result} ->
        {:ok, Map.from_struct(result)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, changeset, :validation}

      error ->
        error
    end
  end
end
