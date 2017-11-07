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

end
