defmodule ValidatorDemoWeb.UserJSON do
  def render("user.json", user: user) do
    %{
      id: user.id,
      email: user.email,
      nickname: user.nickname,
      inserted_at: user.inserted_at
    }
  end

  def render("index.json", users: users) do
    %{users: Enum.map(users, &render("user.json", user: &1))}
  end
end
