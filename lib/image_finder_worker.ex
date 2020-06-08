defmodule ImageFinder.Worker do
  use GenServer, restart: :transient

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: ImageFinder.Worker)
  end

  def init(:ok) do
    IO.puts "starting worker"
    {:ok, %{}}
  end

  def handle_cast({:fetch, source_file, target_directory}, state) do
    File.stream!(source_file)
      |> Stream.map(&handle_line(&1, target_directory))
      |> Stream.run

    {:noreply, state}
  end

  def handle_line(line, target_directory) do
    LineHandler.parse_and_download(line, target_directory)
  end
end
