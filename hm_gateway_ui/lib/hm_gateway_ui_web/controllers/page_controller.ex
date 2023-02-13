defmodule HmGatewayUiWeb.PageController do
  use HmGatewayUiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
