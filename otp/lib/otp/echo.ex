defmodule OTP.Echo do
  @receive_timeout 50

  def start_link do
                   # module, function, agument
    pid = spawn_link(OTP.Echo, :loop, [])
    {:ok, pid}
  end

  def async_send(pid, msg) do
    Kernel.send(pid, {msg, self()})
  end

  def loop do
    receive do
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