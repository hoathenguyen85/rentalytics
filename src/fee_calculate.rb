require_relative 'dependencies'

require 'json'
require 'time_difference'

class FeeCalculate
  def initialize(guest_json_data)
    # initialize with the information on the guest
    @guest = guest_json_data
  end

  def self.marketing_card
    marketing_file = File.new('../data/marketing_card.json')

    JSON.parse(marketing_file.read)
  end

  def marketing_source
    @guest['marketing_source']
  end

  def market_info
    self.class.marketing_card.find {|market| market['name'] == @guest['marketing_source']}
  end

  def type
    if(market_info['monthly'] == true)
      return 'monthly'
    elsif(market_info['per_lease'] == true && market_info['percentage'].nil?)
      return 'per_lease'
    elsif(market_info['per_lease'] == true && market_info['percentage'] == true)
      return 'per_lease_or_percentage'
    end
  end

  # output: the fee of the guest
  def fee
    # calculate the monthly fee of the guest
    case(self.type)
    when('monthly')
      start_time = Time.parse(@guest['first_seen'])

      end_time = Time.now

      unless(@guest['lease_signed'].nil?)
        end_time = Time.parse(@guest['lease_signed'])
      end

      month_diff = TimeDifference.between(start_time, end_time).in_months

      month_diff_round_up = month_diff.ceil

      return month_diff_round_up * market_info['price']
    # if per_lease, give price is signed else $0
    when('per_lease')
      return @guest['lease_signed'].nil? ? 0 : market_info['price']
    when('per_lease_or_percentage')
      lease_price = market_info['price']
      rent_percentage = market_info['price_percentage'] * @guest['resident_rent']

      highest_price = lease_price > rent_percentage ? lease_price : rent_percentage

      return highest_price
    end
  end
end