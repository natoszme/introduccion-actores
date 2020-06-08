defmodule ImageFinder.Supervisor do
  use Supervisor

  def start_link do
  	options = [ strategy: :one_for_one, name: ImageFinder.Supervisor ]
    Supervisor.start_link(children(), options)
  end

  def init(:ok) do
  	[]
  end

  def children() do
	[ ImageFinder.Worker, ImageDownloader.Supervisor, DomainDownloader ]
  end
end
