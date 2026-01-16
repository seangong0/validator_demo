defmodule ValidatorDemoWeb.ErrorJSON do
  @moduledoc """
  This module is invoked by your endpoint in case of errors on JSON requests.

  See config/config.exs.
  """
  alias ValidatorDemoWeb.Helpers.ApiResponse

  def render("404.json", _assigns) do
    ApiResponse.json_response(false, %{}, "Not Found", 404)
  end

  def render("500.json", _assigns) do
    ApiResponse.json_response(false, %{}, "Internal Server Error", 500)
  end

  def render(template, _assigns) do
    ApiResponse.json_response(
      false,
      %{},
      Phoenix.Controller.status_message_from_template(template),
      500
    )
  end
end
