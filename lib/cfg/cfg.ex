defmodule Config do
  def datacity_url do
    System.get_env("DATACITY_URL")
  end
  def datacity_queue_url do
    System.get_env("DATACITY_QUEUE_URL")
  end
  def datacity_queue do
    System.get_env("DATACITY_QUEUE")
  end
  def datacity_api_key do
    System.get_env("DATACITY_API_KEY")
  end
  def job_name do
    System.get_env("JOB_NAME")
  end
  def custodian_url do
    System.get_env("CUSTODIAN_URL")
  end
end
