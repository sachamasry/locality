defmodule Locality.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LocalityWeb.Telemetry,
      Locality.Repo,
      {Ecto.Migrator,
        repos: Application.fetch_env!(:locality, :ecto_repos),
        skip: skip_migrations?()},
      {DNSCluster, query: Application.get_env(:locality, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Locality.PubSub},
      # Start a worker by calling: Locality.Worker.start_link(arg)
      # {Locality.Worker, arg},
      # Start to serve requests, typically the last entry
      LocalityWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Locality.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LocalityWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp skip_migrations?() do
    # By default, sqlite migrations are run when using a release
    System.get_env("RELEASE_NAME") != nil
  end
end
