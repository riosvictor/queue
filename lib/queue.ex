defmodule Queue do
  use GenServer

  # Client
  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  def enqueue(pid, element) do
    GenServer.cast(pid, {:enqueue, element})
  end

  def dequeue(pid) do
    GenServer.call(pid, :dequeue)
  end

  def is_empty(pid) do
    GenServer.call(pid, :is_empty)
  end

  def show(pid) do
    GenServer.call(pid, :show)
  end

  #
  # Server
  @impl true
  def init(stack) do
    {:ok, stack}
  end

  # SYNC
  @impl true
  def handle_call(:dequeue, _from, queue) do
    case queue do
      [head | tail] -> {:reply, head, tail}
      empty_list -> {:reply, nil, empty_list}
    end
  end

  @impl true
  def handle_call(:is_empty, _from, queue) do
    {:reply, length(queue) == 0, queue}
  end

  @impl true
  def handle_call(:show, _from, queue) do
    {:reply, queue, queue}
  end

  # ASYNC
  @impl true
  def handle_cast({:enqueue, element}, queue) do
    {:noreply, queue ++ ["#{element}"]}
  end
end
