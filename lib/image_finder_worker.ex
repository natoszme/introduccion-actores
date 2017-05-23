defmodule ImageFinder.Worker do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, :ok, name: name)
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:fetch, source_file, target_directory}, _from, state) do
    content = File.read source_file
    regexp = ~r/http(s?)\:.*?\.(png|jpg|gif)/
    Regex.scan(regexp, content)
      |> Enum.map(&List.first/1)
      |> Enum.map(&(download_into &1, target_directory))

    {:reply, :ok, state}
  end

  def download_into(url, directory) do
    result = HTTPotion.get url
    File.write directory, url
  end
end
