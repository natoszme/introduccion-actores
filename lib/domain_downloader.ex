defmodule DomainDownloader do
	use GenServer

	def start_link(_opts) do
		GenServer.start_link(__MODULE__, :ok, name: DomainDownloader)
	end

	def init(state) do
		Registry.start_link(keys: :unique, name: DomainRegistry)
		{:ok, state}
	end

	def handle_cast({:download, {link, target}}, state) do
		download(link, target)
		{:noreply, state}
	end

	def download(link, target) do
		domain = Enum.at(String.split(link, "/"), 2)
	    IO.inspect(domain)
	    downloader = Registry.lookup(DomainRegistry, domain) |> List.first

	    IO.puts "found downloader"
	    IO.inspect downloader

	    if (!downloader) do
			{:ok, downloader} = ImageDownloader.Supervisor.downloader(domain)

	    	#GenServer.call(downloader, {:handle_domain, domain})
	    	GenServer.cast(downloader, {:download, {link, target}})
		else
		    {downloader, _links} = downloader
		    IO.puts "existing downloader"
	    	IO.inspect downloader

		    GenServer.cast(downloader, {:download, {link, target}})
		end
	end
end