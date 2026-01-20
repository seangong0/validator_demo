defmodule ValidatorDemoWeb.ErrorJSON do
  @moduledoc """
  This module is invoked by your endpoint in case of errors on JSON requests.

  See config/config.exs.
  """
  alias ValidatorDemoWeb.Helpers.ApiResponse

  def render("404.json", _assigns) do
    ApiResponse.json_response(false, %{}, :not_found, 404)
  end

  def render("500.json", _assigns) do
    ApiResponse.json_response(false, %{}, :internal_server_error, 500)
  end

  def render(_template, _assigns) do
    ApiResponse.json_response(false, %{}, :internal_server_error, 500)
  end
end
