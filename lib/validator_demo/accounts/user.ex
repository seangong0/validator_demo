defmodule ValidatorDemo.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Bcrypt

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :nickname, :string

    timestamps()
  end

  def create_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :nickname])
    |> validate_required([:email, :password, :nickname])
    |> validate_length(:password, min: 8)
    |> unique_constraint(:email)
    |> hash_password_if_present()
  end

  def update_changeset(user, attrs) do
    user
    |> cast(attrs, [:nickname, :password])
    |> validate_required([:nickname])
    |> hash_password_if_present()
  end

  defp hash_password_if_present(changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      password -> put_change(changeset, :password_hash, hash_pwd_salt(password))
    end
  end

  def verify_password(user, password) do
    verify_pass(password, user.password_hash)
  end
end
