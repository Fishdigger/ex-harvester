defmodule Queue do

  def connect do
    AMQP.Connection.open(Config.datacity_queue_url)
  end

  def get_channel(connection) do
    AMQP.Channel.open(connection)
  end

  def close(connection) do
    AMQP.Connection.close(connection)
  end

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
