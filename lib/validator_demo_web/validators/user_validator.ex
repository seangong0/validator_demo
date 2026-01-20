defmodule ValidatorDemoWeb.Validators.UserValidator do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  Input validation for user operations.
  Returns {:ok, map} or {:error, Ecto.Changeset.t(), :validation}.
  """

  @email_regex ~r/^[^\s]+@[^\s]+$/

  embedded_schema do
    field :email, :string
    field :password, :string
    field :nickname, :string
  end

  def validate_create(params) do
    %__MODULE__{}
    |> cast(params, [:email, :password, :nickname])
    |> validate_required([:email, :password, :nickname])
    |> validate_format(:email, @email_regex, message: "must be a valid email")
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
