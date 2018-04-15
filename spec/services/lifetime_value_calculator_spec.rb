require 'rails_helper'

describe LifetimeValueCalculator, type: :model do
  let(:orders) do
    [
      { id: 1, customer_id: 1, status: 'Awaiting Fulfillment', products: [{ id: 1 }], date_created: 'Fri, 09 Feb 2018 12:00:45 +0000', total_inc_tax: '80.0', currency_code: 'USD' },
      { id: 2, customer_id: 1, status: 'Awaiting Fulfillment', products: [{ id: 1 }], date_created: 'Sat, 10 Feb 2018 12:00:45 +0000', total_inc_tax: '120.0', currency_code: 'USD' },
      { id: 3, customer_id: 1, status: 'Awaiting Fulfillment', products: [{ id: 1 }], date_created: 'Mon, 14 Mar 2018 06:10:45 +0000', total_inc_tax: '200.0', currency_code: 'USD' },
      { id: 4, customer_id: 1, status: 'Awaiting Fulfillment', products: [{ id: 1 }], date_created: 'Wed, 04 Apr 2018 23:50:45 +0000', total_inc_tax: '140.0', currency_code: 'USD' },
      { id: 5, customer_id: 1, status: 'Awaiting Fulfillment', products: [{ id: 1 }], date_created: 'Tue, 10 Apr 2018 23:50:45 +0000', total_inc_tax: '60.0', currency_code: 'USD' },
    ]
  end

  subject { LifetimeValueCalculator.new(Order.all(orders)) }

  before(:each) do
    allow(Bigcommerce::Order).to receive(:all).and_return(orders)
  end

  describe '#months' do
    it 'returns the number of months' do
      expect(subject.months).to eql(3)
    end

    context 'when no orders' do
      it 'returns zero' do
        expect(LifetimeValueCalculator.new([]).months).to eql(0)
      end
    end
  end

  describe '#total_amount' do
    it 'returns the total amount' do
      expect(subject.total_amount).to eql(600.0)
    end

    context 'when no orders' do
      it 'returns zero' do
        expect(LifetimeValueCalculator.new([]).total_amount).to eql(0.0)
      end
    end
  end

  describe '#value' do
    it 'returns the value' do
      expect(subject.value).to eql(200.0)
    end

    context 'when no orders' do
      it 'returns zero' do
        expect(LifetimeValueCalculator.new([]).value).to eql(0.0)
      end
    end
  end
end
