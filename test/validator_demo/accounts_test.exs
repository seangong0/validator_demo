defmodule ValidatorDemo.AccountsTest do
  use ValidatorDemo.DataCase, async: true
  alias ValidatorDemo.Accounts
  alias ValidatorDemo.Accounts.User

  describe "create_user/1" do
    test "creates a user with valid attributes" do
      attrs = %{email: "test@example.com", password: "password123", nickname: "testuser"}

      assert {:ok, %User{} = user} = Accounts.create_user(attrs)
      assert user.email == "test@example.com"
      assert user.nickname == "testuser"
      assert user.password_hash != nil
    end

    test "returns error for invalid attributes" do
      attrs = %{email: "test@example.com", password: "short", nickname: "testuser"}

      assert {:error, changeset} = Accounts.create_user(attrs)
      refute changeset.valid?
    end

    test "creates unique emails" do
      attrs = %{email: "unique@example.com", password: "password123", nickname: "user1"}

      assert {:ok, _user} = Accounts.create_user(attrs)
      assert {:error, changeset} = Accounts.create_user(attrs)

      assert {"has already been taken",
              [constraint: :unique, constraint_name: "users_email_index"]} =
               changeset.errors[:email]
    end
  end

  describe "update_user/2" do
    test "updates user nickname" do
      {:ok, user} =
        Accounts.create_user(%{
          email: "test@example.com",
          password: "password123",
          nickname: "oldname"
        })

      assert {:ok, updated_user} = Accounts.update_user(user, %{nickname: "newname"})
      assert updated_user.nickname == "newname"
    end

    test "updates user password" do
      {:ok, user} =
        Accounts.create_user(%{
          email: "test@example.com",
          password: "password123",
          nickname: "testuser"
        })

      assert {:ok, updated_user} = Accounts.update_user(user, %{password: "newpassword123"})
      assert updated_user.password_hash != user.password_hash
      assert User.verify_password(updated_user, "newpassword123")
    end
  end

  describe "list_users/0" do
    test "returns all users" do
      {:ok, _user1} =
        Accounts.create_user(%{
          email: "user1@example.com",
          password: "password123",
          nickname: "user1"
        })

      {:ok, _user2} =
        Accounts.create_user(%{
          email: "user2@example.com",
          password: "password123",
          nickname: "user2"
        })

      users = Accounts.list_users()
      assert length(users) == 2
    end

    test "returns empty list when no users" do
      assert Accounts.list_users() == []
    end
  end

  describe "get_user!/1" do
    test "returns user by id" do
      {:ok, user} =
        Accounts.create_user(%{
          email: "test@example.com",
          password: "password123",
          nickname: "testuser"
        })

      fetched_user = Accounts.get_user!(user.id)
      assert fetched_user.id == user.id
      assert fetched_user.email == user.email
    end

    test "raises error for invalid id" do
      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_user!(Ecto.UUID.generate())
      end
    end
  end

  describe "authenticate_user/2" do
    setup do
      {:ok, user} =
        Accounts.create_user(%{
          email: "auth@example.com",
          password: "correct_password",
          nickname: "testuser"
        })

      %{email: user.email}
    end

    test "returns user with correct password", %{email: email} do
      assert {:ok, %User{email: ^email}} =
               Accounts.authenticate_user("auth@example.com", "correct_password")
    end

    test "returns error with wrong password" do
      assert {:error, :invalid_password} =
               Accounts.authenticate_user("auth@example.com", "wrong_password")
    end

    test "returns error for non-existent email" do
      assert {:error, :user_not_found} =
               Accounts.authenticate_user("nonexistent@example.com", "password")
    end
  end
end
