defmodule ValidatorDemoWeb.Helpers.ApiResponse do
  import Plug.Conn
  import Phoenix.Controller

  # ============ 成功响应 ============

  def ok(conn, result \\ %{}), do: success(conn, result, 200)

  def created(conn, result \\ %{}, location \\ nil) do
    conn
    |> put_status(201)
    |> maybe_put_location(location)
    |> json(build_response(201, true, result, []))
  end

  def no_content(conn), do: put_status(conn, 204) |> json(nil)

  def success(conn, result \\ %{}, status_code \\ 200) do
    render_api(conn, status_code, true, result, [])
  end

  # ============ 错误响应 ============

  def bad_request(conn, errors \\ "Bad Request"), do: failed(conn, errors, 400)

  def unauthorized(conn, errors \\ "Unauthorized"), do: failed(conn, errors, 401)

  def forbidden(conn, errors \\ "Forbidden"), do: failed(conn, errors, 403)

  def not_found(conn, errors \\ "Not Found"), do: failed(conn, errors, 404)

  def conflict(conn, errors \\ "Conflict"), do: failed(conn, errors, 409)

  def unprocessable_entity(conn, errors), do: failed(conn, errors, 422)

  def internal_server_error(conn, errors \\ "Internal Server Error"),
    do: failed(conn, errors, 500)

  def failed(conn, error_data, status_code \\ 400) do
    render_api(conn, status_code, false, %{}, error_data)
  end

  # ============ 结构化响应 ============

  def json_response(success, result \\ %{}, errors \\ [], status_code \\ 200) do
    build_response(status_code, success, result, errors)
  end

  # ============ 内部函数 ============

  defp maybe_put_location(conn, nil), do: conn

  defp maybe_put_location(conn, location),
    do: put_resp_header(conn, "location", to_string(location))

  defp render_api(conn, status_code, success, result, errors) do
    conn
    |> put_status(status_code)
    |> json(build_response(status_code, success, result, errors))
  end

  defp build_response(status_code, success, result, errors) do
    %{
      success: success,
      data: result,
      errors: format_errors(errors)
    }
    |> maybe_put_status_code(status_code)
  end

  defp maybe_put_status_code(response, status_code) when is_integer(status_code),
    do: Map.put(response, :status_code, status_code)

  defp maybe_put_status_code(response, _), do: response

  defp format_errors(%Ecto.Changeset{} = changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.map(fn {k, v} -> "#{k} #{Enum.join(v, ", ")}" end)
  end

  defp format_errors(errors) when is_list(errors), do: errors
  defp format_errors(error) when is_binary(error), do: [error]
  defp format_errors(nil), do: []
  defp format_errors(_), do: ["Unknown error"]
end
