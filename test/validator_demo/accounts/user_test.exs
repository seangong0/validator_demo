defmodule ValidatorDemo.Accounts.UserTest do
  use ValidatorDemo.DataCase, async: true
  alias ValidatorDemo.Accounts.User
  import Bcrypt

  describe "create_changeset/2" do
    test "creates user changeset with hashed password" do
      attrs = %{email: "test@example.com", password: "password123", nickname: "testuser"}

      changeset = User.create_changeset(%User{}, attrs)

      assert get_change(changeset, :email) == "test@example.com"
      assert get_change(changeset, :nickname) == "testuser"
      assert password_hash = get_change(changeset, :password_hash)
      assert is_binary(password_hash)
      refute password_hash == "password123"
      assert get_change(changeset, :password) == "password123"
      assert get_change(changeset, :password_hash) != nil
    end

    # Note: Validation is done in UserValidator, not in the model
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

      new_hash = get_change(changeset, :password_hash)
      assert new_hash != "old_hash"
      assert is_binary(new_hash)
    end

    test "does not change hash when password not updated" do
      old_hash = hash_pwd_salt("password123")
      user = %User{email: "test@example.com", nickname: "testuser", password_hash: old_hash}

      attrs = %{nickname: "newname"}
      changeset = User.update_changeset(user, attrs)

      refute get_change(changeset, :password_hash)
    end
  end
end
