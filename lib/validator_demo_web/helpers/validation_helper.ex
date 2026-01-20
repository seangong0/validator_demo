defmodule ValidatorDemoWeb.Helpers.ValidationHelper do
  @moduledoc """
  Shared validation helpers for common validation patterns.
  """

  @doc """
  Validates that a string is a valid UUID format.

  ## Examples

      iex> validate_uuid("a1b2c3d4-e5f6-7890-abcd-ef1234567890")
      :ok

      iex> validate_uuid("invalid-uuid")
      {:error, "invalid UUID format"}

  """
  @spec validate_uuid(binary()) :: :ok | {:error, String.t()}
  def validate_uuid(id) when is_binary(id) do
    case Ecto.Type.cast(Ecto.UUID, id) do
      {:ok, _} -> :ok
      :error -> {:error, "invalid UUID format"}
    end
  end

  def validate_uuid(_id), do: {:error, "id must be a UUID"}

  @doc """
  Validates that an ID is present and is a valid UUID.
  """
  @spec validate_id(Ecto.UUID.t() | nil) :: :ok | {:error, String.t()}
  def validate_id(nil), do: {:error, "id is required"}
  def validate_id(id), do: validate_uuid(id)
end
