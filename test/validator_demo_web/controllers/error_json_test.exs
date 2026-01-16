defmodule ValidatorDemoWeb.ErrorJSONTest do
  use ValidatorDemoWeb.ConnCase, async: true

  test "renders 404" do
    assert ValidatorDemoWeb.ErrorJSON.render("404.json", %{}) == %{errors: "Not Found"}
  end

  test "renders 500" do
    assert ValidatorDemoWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: "Internal Server Error", status_code: 500}
  end
end
