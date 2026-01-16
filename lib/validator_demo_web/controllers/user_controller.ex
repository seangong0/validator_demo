defmodule ValidatorDemoWeb.UserController do
  use ValidatorDemoWeb, :controller
  alias ValidatorDemo.Accounts
  alias ValidatorDemoWeb.Validators.UserValidator
  alias ValidatorDemoWeb.UserJSON

  def create(conn, unsafe_params) do
    with {:ok, params} <- UserValidator.validate_create(unsafe_params),
         {:ok, user} <- Accounts.create_user(params) do
      data = UserJSON.render("user.json", user: user)
      created(conn, data, ~p"/api/users/#{user.id}/")
    else
      {:error, %Ecto.Changeset{} = changeset, :validation} ->
        bad_request(conn, changeset)

      {:error, %Ecto.Changeset{} = changeset} ->
        unprocessable_entity(conn, changeset)

      {:error, reason} when is_atom(reason) ->
        unprocessable_entity(conn, reason)
    end
  end

  def show(conn, %{"id" => id}) do
    case UserValidator.validate_uuid(id) do
      {:error, reason} ->
        bad_request(conn, reason)

      :ok ->
        case Accounts.get_user(id) do
          nil ->
            not_found(conn, "User not found")

          user ->
            data = UserJSON.render("user.json", user: user)
            ok(conn, data)
        end
    end
  end

  def index(conn, _params) do
    users = Accounts.list_users()
    data = UserJSON.render("index.json", users: users)
    ok(conn, data)
  end
end
