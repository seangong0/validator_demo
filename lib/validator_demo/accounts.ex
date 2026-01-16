defmodule ValidatorDemo.Accounts do
  import Ecto.Query, warn: false
  alias ValidatorDemo.Repo
  alias ValidatorDemo.Accounts.User

  @spec get_user!(Ecto.UUID.t()) :: User.t()
  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id), do: Repo.get(User, id)

  def list_users do
    Repo.all(User)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.create_changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.update_changeset(attrs)
    |> Repo.update()
  end

  def authenticate_user(email, password) do
    case get_user_by_email(email) do
      %User{} = user ->
        if User.verify_password(user, password) do
          {:ok, user}
        else
          {:error, :invalid_password}
        end

      nil ->
        {:error, :user_not_found}
    end
  end

  defp get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end
end
