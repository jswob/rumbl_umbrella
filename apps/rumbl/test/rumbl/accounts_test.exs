defmodule Rumbl.AccountsTest do
  use Rumbl.DataCase, async: true

  alias Rumbl.Accounts
  alias Rumbl.Accounts.User

  @valid_attrs %{
    name: "some_name",
    username: "user1",
    password: "secret"
  }
  @invalid_attrs %{}
  @pass "123456"

  describe "register_user/1" do
    test "with correct data insert user" do
      assert {:ok, %User{id: id} = user} = Accounts.register_user(@valid_attrs)
      assert user.name == "some_name"
      assert user.username == "user1"
      assert [%User{id: ^id}] = Accounts.list_users()
    end

    test "with invalid data does not insert a user" do
      assert {:error, _changeset} = Accounts.register_user(@invalid_attrs)
      assert [] == Accounts.list_users()
    end

    test "enforces unique usernames" do
      {:ok, %User{id: id}} = Accounts.register_user(@valid_attrs)
      {:error, changeset} = Accounts.register_user(@valid_attrs)

      assert %{username: ["has already been taken"]} = errors_on(changeset)

      assert [%User{id: ^id}] = Accounts.list_users()
    end

    test "does not accept long usernames" do
      user = Map.put(@valid_attrs, :username, String.duplicate("a", 30))
      {:error, changeset} = Accounts.register_user(user)

      assert %{username: ["should be at most 20 character(s)"]} = errors_on(changeset)

      assert [] == Accounts.list_users()
    end

    test "requires password to be at least 6 chars long" do
      user = Map.put(@valid_attrs, :password, "aaa")
      {:error, changeset} = Accounts.register_user(user)

      assert %{password: ["should be at least 6 character(s)"]} = errors_on(changeset)

      assert [] == Accounts.list_users()
    end
  end

  describe "authenticate_by_username_and_pass/2" do
    setup do
      {:ok, user: user_fixture(password: @pass)}
    end

    test "returns user with correct password", %{user: user} do
      assert {:ok, auth_user} = Accounts.authenticate_by_username_and_pass(user.username, @pass)
      assert auth_user.id == user.id
    end

    test "returns unauthorized error with invalid password", %{user: user} do
      assert {:error, :unauthorized} =
               Accounts.authenticate_by_username_and_pass(user.username, "badpass")
    end

    test "returns not found error with no matching user for email" do
      assert {:error, :not_found} = Accounts.authenticate_by_username_and_pass("not_found", @pass)
    end
  end
end
