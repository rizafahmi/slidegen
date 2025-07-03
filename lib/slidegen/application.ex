defmodule Slidegen.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SlidegenWeb.Telemetry,
      Slidegen.Repo,
      {DNSCluster, query: Application.get_env(:slidegen, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Slidegen.PubSub},
      # Start a worker by calling: Slidegen.Worker.start_link(arg)
      # {Slidegen.Worker, arg},
      # Start to serve requests, typically the last entry
      SlidegenWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Slidegen.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SlidegenWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
