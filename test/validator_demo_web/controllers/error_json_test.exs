defmodule ValidatorDemoWeb.ErrorJSONTest do
  use ValidatorDemoWeb.ConnCase, async: true

  test "renders 404" do
    assert ValidatorDemoWeb.ErrorJSON.render("404.json", %{}) == %{
             data: %{},
             success: false,
             errors: ["not_found"],
             status_code: 404
           }
  end

  test "renders 500" do
    assert ValidatorDemoWeb.ErrorJSON.render("500.json", %{}) == %{
             data: %{},
             success: false,
             errors: ["internal_server_error"],
             status_code: 500
           }
  end
end
