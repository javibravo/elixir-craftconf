defmodule OTP.Echo do
  @receive_timeout 50
  @send_timeout 10

  def start_link do
                   # module, function, agument
    pid = spawn_link(OTP.Echo, :loop, [])
    {:ok, pid}
  end

  def sync_send(pid, msg) do
    async_send(pid, msg)
    receive do
      msg -> msg
    after
      @send_timeout ->
        {:error, :timeout}
    end
  end

  def async_send(pid, msg) do
    Kernel.send(pid, {msg, self()})
  end

  def loop do
    receive do
      {:no_reply, _caller} ->
        loop()
      {msg, caller} ->
        Kernel.send(caller, msg)
        loop()
      _msg -> # _ (underscore), I am going to catch it but not use it
        loop()
    after
      @receive_timeout ->
        exit(:normal)
    end
  end

end