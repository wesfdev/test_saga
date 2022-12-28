defmodule SagaRetry do
  def run() do
    attrs = %{"orderId" => "1234", "location" => [1, 1], "store" => 3}
    response = create_and_subscribe_task(attrs)
    IO.puts("====> response: #{inspect(response)}")
    response
  end

  @spec create_and_subscribe_task(any) :: {:error, any} | {:ok, any, map}
  def create_and_subscribe_task(attrs) do
    Sage.new()
    |> Sage.run(:task, &create_task/2, &try_again/3)
    |> Sage.run(:brands, &fetch_brands/2, &try_again/3)
    |> Sage.run(:kafka_event, &dispatch_kafka/2, &try_again/3)
    |> Sage.execute(attrs)
  end

  defp create_task(effects_so_far, attrs) do
    IO.puts("=============== create_task ===============")
    IO.puts("---> effects_so_far: #{inspect(effects_so_far)}")
    IO.puts("---> attrs: #{inspect(attrs)}")
    {:ok, %{task_id: 1}}
  end

  defp fetch_brands(effects_so_far, attrs) do
    IO.puts("=============== fetch_brands ===============")
    IO.puts("---> effects_so_far: #{inspect(effects_so_far)}")
    IO.puts("---> attrs: #{inspect(attrs)}")
    {:error, %{brand_id: 2}}
  end

  defp dispatch_kafka(effects_so_far, attrs) do
    IO.puts("=============== dispatch_kafka ===============")
    IO.puts("---> effects_so_far: #{inspect(effects_so_far)}")
    IO.puts("---> attrs: #{inspect(attrs)}")
    {:ok, %{event_kafka_id: 3}}
  end

  def try_again(
        _effect_to_compensate,
        _data,
        _attrs
      ) do
    {:retry, retry_limit: 2, base_backoff: 10, max_backoff: 30_000, enable_jitter: true}
  end
end
