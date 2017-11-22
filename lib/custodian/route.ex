defmodule Custodian.Route do
  def build_since_route(%{StartDate: start_date, EndDate: end_date}) do
    "#{Config.custodian_url()}/#{start_date}/#{end_date}"
  end
end
