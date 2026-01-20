defmodule ValidatorDemoWeb.UserController do
  use ValidatorDemoWeb, :controller
  alias ValidatorDemo.Accounts
  alias ValidatorDemoWeb.Validators.UserValidator
  alias ValidatorDemoWeb.UserJSON
  alias ValidatorDemoWeb.Helpers.ValidationHelper

  def create(conn, unsafe_params) do
    with {:ok, params} <- UserValidator.validate_create(unsafe_params),
         {:ok, user} <- Accounts.create_user(params) do
      data = UserJSON.render("user.json", user: user)
      created(conn, data, ~p"/api/users/#{user.id}/")
    else
      {:error, changeset, :validation} ->
        bad_request(conn, changeset)

      {:error, changeset} ->
        conflict(conn, changeset)

      {:error, reason} when is_atom(reason) ->
        unprocessable_entity(conn, reason)
    end
  end

  def show(conn, %{"id" => id}) do
    with :ok <- ValidationHelper.validate_uuid(id) do
      case Accounts.get_user(id) do
        nil ->
          not_found(conn, :user_not_found)

        user ->
          data = UserJSON.render("user.json", user: user)
          ok(conn, data)
      end
    else
      {:error, _reason} ->
        bad_request(conn, :invalid_id_format)
    end
  end

  def index(conn, _params) do
    users = Accounts.list_users()
    data = UserJSON.render("index.json", users: users)
    ok(conn, data)
  end
end
