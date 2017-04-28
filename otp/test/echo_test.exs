defmodule OTP.EchoTest do
    use ExUnit.Case, async: true

    # alias OTP.Echo, as :WhateverYouWant
    alias OTP.Echo

    test "echo" do
      {:ok, pid} = Echo.start_link()

      Echo.async_send(pid, :hello)
      assert_receive :hello

      Echo.async_send(pid, :hello)
      assert_receive :hello

      send(pid, :another_message) # Kernel.send
      assert Process.alive?(pid)
    end

    test "time out after 50 ms" do
      {:ok, pid} = Echo.start_link()

      Process.sleep(51)
      refute Process.alive?(pid)
    end

    test "sync echo" do
      {:ok, pid} = Echo.start_link()

      assert :hello == Echo.sync_send(pid, :hello)
    end
end
