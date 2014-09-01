
require 'date'

module DateHelpers
  def parse_date(date)
    if date.kind_of? String
      date = begin
        Date.parse(date) 
      rescue
        Date.strptime(date, "%m/%d/%Y")
      end
    end
    date
  end
end

