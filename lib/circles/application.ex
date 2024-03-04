defmodule Circles.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CirclesWeb.Telemetry,
      Circles.Repo,
      {DNSCluster, query: Application.get_env(:circles, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Circles.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Circles.Finch},
      # Start a worker by calling: Circles.Worker.start_link(arg)
      # {Circles.Worker, arg},
      # Start to serve requests, typically the last entry
      CirclesWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Circles.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CirclesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
