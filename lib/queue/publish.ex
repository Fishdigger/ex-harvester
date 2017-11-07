defmodule Queue do

  def publish(channel, obj) do
    msg = Poison.encode!(obj)
    AMQP.Basic.publish(channel, "", "", msg, [
      content_type: "application/json",
      mandatory: true,
      persistent: false,
      priority: 0
      ])
  end

end
