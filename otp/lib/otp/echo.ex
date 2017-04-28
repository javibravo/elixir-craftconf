defmodule OTP.Echo do

  def start_link do
                   # module, function, agument
    pid = spawn_link(OTP.Echo, :loop, [])
    {:ok, pid}
  end

  def send(pid, msg) do
    Kernel.send(pid, {msg, self()})
  end

  def loop do
    receive do
      {msg, caller} ->
        Kernel.send(caller, msg)
    end
  end

end