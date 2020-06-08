defmodule LineHandler do
	use GenServer

	def start_link(state) do
		GenServer.start_link(__MODULE__, state)
	end

	#TODO deberia morirse despues de terminar de procesar el parse_and_download
	def init(state) do
		GenServer.cast(self(), {:parse_and_download})
		{:ok, state}
	end

	def handle_cast({:parse_and_download}, {line, target_directory}) do
		regexp = ~r/http(s?)\:.*?\.(png|jpg|gif)/
	    Regex.scan(regexp, line)
	      |> links_from_regex()
	      |> fetch_links(target_directory)
		{:noreply, {line, target_directory}}
	end

	def parse_and_download(line, target_directory) do
		LineHandler.start_link({line, target_directory})
	end

	def links_from_regex(line) do
		Enum.map(line, &List.first/1)
	end

	def fetch_links(links, target_directory) do
		Enum.each(links, &(fetch_link &1, target_directory))
	end

	def fetch_link(link, target_directory) do
		#ImageDownloader.Supervisor.download(link, target_directory)
		GenServer.cast(DomainDownloader, {:download, {link, target_directory}})
	end
end