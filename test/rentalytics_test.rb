require_relative '../src/fee_calculate'

describe FeeCalculate do

  before :each do
    # before all test stub with test marketing_card json file 
    allow(FeeCalculate).to receive(:marketing_card).and_return(JSON.parse(File.new('./data/marketing_card.json').read))
  end

  context 'monthly cost' do
    let(:month) {FeeCalculate.new(JSON.parse(File.new('./data/monthly.json').read))}
    let(:three_month) {FeeCalculate.new(JSON.parse(File.new('./data/three_month.json').read))}

    # get the company as a monthly cost
    it 'is found as monthly' do
      expect(month.type).to eq('monthly')
    end

    it 'is calculated for a month' do
      expect(month.fee).to eq(495)
    end

    it 'is calculated for 3 months' do
      expect(three_month.fee).to eq(1485)
    end
  end

  context 'per lease cost' do
    let(:signed_lease) {FeeCalculate.new(JSON.parse(File.new('./data/signed_lease.json').read))}
    let(:unsigned_lease) {FeeCalculate.new(JSON.parse(File.new('./data/unsigned_lease.json').read))}

    # get the company as a monthly cost
    it 'is found as per_lease' do
      expect(signed_lease.type).to eq('per_lease')
    end

    it 'is calculated for a signed lease' do
      expect(signed_lease.fee).to eq(295)
    end

    it 'is calculated for a non-signed lease' do
      expect(unsigned_lease.fee).to eq(0)
    end
  end

  context 'per lease cost' do
    let(:low_rent) {FeeCalculate.new(JSON.parse(File.new('./data/low_rent.json').read))}
    let(:high_rent) {FeeCalculate.new(JSON.parse(File.new('./data/high_rent.json').read))}

    # get the company as a monthly cost
    it 'is found as per_lease_or_percentage' do
      expect(low_rent.type).to eq('per_lease_or_percentage')
    end

    it 'is calculated for a lower rent price' do
      expect(low_rent.fee).to eq(595)
    end

    it 'is calculated for a higher rent price' do
      expect(high_rent.fee).to eq(600)
    end
  end
end