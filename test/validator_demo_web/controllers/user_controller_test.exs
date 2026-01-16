defmodule ValidatorDemoWeb.UserControllerTest do
  use ValidatorDemoWeb.ConnCase

  alias ValidatorDemo.Accounts

  describe "create/2" do
    test "creates user successfully with valid params", %{conn: conn} do
      params = %{
        "email" => "test@example.com",
        "password" => "password123",
        "nickname" => "testuser"
      }

      conn = post(conn, ~p"/api/users", params)

      response = json_response(conn, 201)
      assert response["success"] == true
      assert response["data"]["email"] == "test@example.com"
      assert response["data"]["nickname"] == "testuser"
    end

    test "returns 400 when email is missing", %{conn: conn} do
      params = %{
        "password" => "password123",
        "nickname" => "testuser"
      }

      conn = post(conn, ~p"/api/users", params)

      response = json_response(conn, 400)
      assert response["success"] == false
      assert response["errors"] != []
    end

    test "returns 400 when password is missing", %{conn: conn} do
      params = %{
        "email" => "test@example.com",
        "nickname" => "testuser"
      }

      conn = post(conn, ~p"/api/users", params)

      response = json_response(conn, 400)
      assert response["success"] == false
      assert response["errors"] != []
    end

    test "returns 400 when nickname is missing", %{conn: conn} do
      params = %{
        "email" => "test@example.com",
        "password" => "password123"
      }

      conn = post(conn, ~p"/api/users", params)

      response = json_response(conn, 400)
      assert response["success"] == false
      assert response["errors"] != []
    end

    test "returns 400 when email format is invalid", %{conn: conn} do
      params = %{
        "email" => "invalid-email",
        "password" => "password123",
        "nickname" => "testuser"
      }

      conn = post(conn, ~p"/api/users", params)

      response = json_response(conn, 400)
      assert response["success"] == false
      assert response["errors"] != []
    end

    test "returns 422 when Accounts.create_user fails with changeset", %{conn: conn} do
      # First create a user
      Accounts.create_user(%{
        "email" => "existing@example.com",
        "password" => "password123",
        "nickname" => "existing"
      })

      params = %{
        "email" => "existing@example.com",
        "password" => "password123",
        "nickname" => "newuser"
      }

      conn = post(conn, ~p"/api/users", params)

      response = json_response(conn, 422)
      assert response["success"] == false
      assert response["errors"] != []
    end
  end

  describe "show/2" do
    test "returns user when user exists", %{conn: conn} do
      {:ok, user} =
        Accounts.create_user(%{
          "email" => "show@example.com",
          "password" => "password123",
          "nickname" => "showuser"
        })

      conn = get(conn, ~p"/api/users/#{user.id}")

      response = json_response(conn, 200)
      assert response["success"] == true
      assert response["data"]["email"] == "show@example.com"
      assert response["data"]["nickname"] == "showuser"
    end

    test "returns 404 when user not found", %{conn: conn} do
      conn = get(conn, ~p"/api/users/00000000-0000-0000-0000-000000000000")

      response = json_response(conn, 404)
      assert response["success"] == false
      assert response["errors"] != []
    end

    test "returns 400 when id is invalid UUID", %{conn: conn} do
      conn = get(conn, ~p"/api/users/invalid-uuid")

      response = json_response(conn, 400)
      assert response["success"] == false
      assert response["errors"] != []
    end
  end

  describe "index/2" do
    test "returns empty list when no users", %{conn: conn} do
      conn = get(conn, ~p"/api/users")

      response = json_response(conn, 200)
      assert response["success"] == true
      assert response["data"]["users"] == []
    end

    test "returns list of users", %{conn: conn} do
      Accounts.create_user(%{
        "email" => "user1@example.com",
        "password" => "password123",
        "nickname" => "user1"
      })

      Accounts.create_user(%{
        "email" => "user2@example.com",
        "password" => "password123",
        "nickname" => "user2"
      })

      conn = get(conn, ~p"/api/users")

      response = json_response(conn, 200)
      assert response["success"] == true
      assert length(response["data"]["users"]) == 2
    end
  end
end
