defmodule LocalityWeb.Router do
  use LocalityWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LocalityWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LocalityWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/mock_locations", MockLocationLive.Index, :index
    live "/mock_locations/new", MockLocationLive.Index, :new
    live "/mock_locations/:id/edit", MockLocationLive.Index, :edit

    live "/mock_locations/:id", MockLocationLive.Show, :show
    live "/mock_locations/:id/show/edit", MockLocationLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", LocalityWeb do
  #   pipe_through :api
  # end
end
