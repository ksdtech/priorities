# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def fmt_dollars(value)
    value < 0 ?
      "(#{number_to_currency(-value, :precision => 0)})" : number_to_currency(value, :precision => 0)
  end
end
