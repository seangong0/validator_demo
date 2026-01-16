defmodule ValidatorDemo.Accounts.UserTest do
  use ValidatorDemo.DataCase, async: true
  alias ValidatorDemo.Accounts.User
  import Bcrypt

  describe "create_changeset/2" do
    test "creates valid user changeset with hashed password" do
      attrs = %{email: "test@example.com", password: "password123", nickname: "testuser"}

      changeset = User.create_changeset(%User{}, attrs)

      assert changeset.valid?
      assert get_change(changeset, :email) == "test@example.com"
      assert get_change(changeset, :nickname) == "testuser"
      assert password_hash = get_change(changeset, :password_hash)
      assert is_binary(password_hash)
      refute password_hash == "password123"
      assert get_change(changeset, :password) == "password123"
      assert get_change(changeset, :password_hash) != nil
    end

    test "validates password minimum length of 8 characters" do
      attrs = %{email: "test@example.com", password: "short", nickname: "testuser"}
      changeset = User.create_changeset(%User{}, attrs)

      assert errors_on(changeset) == %{password: ["should be at least 8 character(s)"]}
    end

    test "validates required fields" do
      changeset = User.create_changeset(%User{}, %{})

      assert errors_on(changeset) == %{
               email: ["can't be blank"],
               password: ["can't be blank"],
               nickname: ["can't be blank"]
             }
    end
  end

  describe "verify_password/2" do
    setup do
      %{user: %User{password_hash: hash_pwd_salt("correct_password")}}
    end

    test "returns true when password matches", %{user: user} do
      assert User.verify_password(user, "correct_password") == true
    end

    test "returns false when password does not match", %{user: user} do
      assert User.verify_password(user, "wrong_password") == false
    end
  end

  describe "update_changeset/2" do
    test "rehashes password when updating" do
      user = %User{email: "test@example.com", nickname: "testuser", password_hash: "old_hash"}

      attrs = %{password: "newpassword123"}
      changeset = User.update_changeset(user, attrs)

      assert changeset.valid?
      new_hash = get_change(changeset, :password_hash)
      assert new_hash != "old_hash"
      assert is_binary(new_hash)
    end

    test "does not change hash when password not updated" do
      old_hash = hash_pwd_salt("password123")
      user = %User{email: "test@example.com", nickname: "testuser", password_hash: old_hash}

      attrs = %{nickname: "newname"}
      changeset = User.update_changeset(user, attrs)

      assert changeset.valid?
      refute get_change(changeset, :password_hash)
    end
  end
end
