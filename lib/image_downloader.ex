defmodule ImageDownloader do
  use GenServer, restart: :transient

  def start_link(domain) do
    GenServer.start_link(__MODULE__, domain)
  end

  def init(domain) do
    #GenServer.cast(self(), {:download, imageWithTarget})
    Registry.register(DomainRegistry, domain, [])
    {:ok, domain}
  end

  # def handle_call({:handle_domain, domain}, _sender, state) do
  #   {:reply, state, state}
  # end

  def handle_cast({:download, {link, target_directory}}, _state) do
    #TODO en el value del registry poner el link si no esta (y si no existe)
    #TODO sacar el primer link del registry
    #TODO que pasa si se muere el downloader? se pierde la key del registry y con ella los links...
    IO.puts link
    fetch_link(link, target_directory)
    {:noreply, {link, target_directory}}
  end

  def download(imageWithTarget) do
    ImageDownloader.start_link(imageWithTarget)
  end

  def fetch_link(link, target_directory) do
    HTTPotion.get(link).body
      |> save(target_directory)
  end

  def save(body, directory) do
    File.write! "#{directory}/#{digest(body)}.png", body
  end

  def digest(body) do
    :crypto.hash(:md5 , body)
      |> Base.encode16()
  end  
end
