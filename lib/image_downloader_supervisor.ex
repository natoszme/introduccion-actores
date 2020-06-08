defmodule ImageDownloader.Supervisor do
	use DynamicSupervisor

	def start_link(_opts) do
		options = [ strategy: :one_for_one, name: ImageDownloader.Supervisor, max_restarts: 10, max_seconds: 10 ]
		DynamicSupervisor.start_link(options)
	end

	def init(:ok) do
		[]
	end

	def downloader(domain) do
		DynamicSupervisor.start_child(ImageDownloader.Supervisor, {ImageDownloader, domain})
	end
end