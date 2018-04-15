require 'rails_helper'

describe Customer, type: :model do
  subject { Customer }
  let(:customers) do
    [
      { id: 1, first_name: 'Danilo', last_name: 'Lo Santo', email: 'dls@gmail.com' },
      { id: 2, first_name: 'Francesco', last_name: 'Danno', email: 'fd@gmail.com' }
    ]
  end

  let(:orders) do
    [
      { id: 1, customer_id: 1, status: 'Awaiting Fulfillment', products: [{ id: 1 }], date_created: 'Fri, 09 Feb 2018 12:00:45 +0000', total_inc_tax: '80.0', currency_code: 'USD' },
      { id: 2, customer_id: 1, status: 'Awaiting Fulfillment', products: [{ id: 1 }], date_created: 'Sat, 10 Feb 2018 12:00:45 +0000', total_inc_tax: '120.0', currency_code: 'USD' },
      { id: 3, customer_id: 1, status: 'Awaiting Fulfillment', products: [{ id: 1 }], date_created: 'Mon, 14 Mar 2018 06:10:45 +0000', total_inc_tax: '200.0', currency_code: 'USD' },
      { id: 4, customer_id: 1, status: 'Awaiting Fulfillment', products: [{ id: 1 }], date_created: 'Wed, 04 Apr 2018 23:50:45 +0000', total_inc_tax: '140.0', currency_code: 'USD' },
      { id: 5, customer_id: 1, status: 'Awaiting Fulfillment', products: [{ id: 1 }], date_created: 'Tue, 10 Apr 2018 23:50:45 +0000', total_inc_tax: '60.0', currency_code: 'USD' },
    ]
  end

  describe '.all' do
    it 'returns a list of Customers' do
      allow(Bigcommerce::Customer).to receive(:all).with(page: 1).and_return(customers)

      customers = subject.all(page: 1)
      expect(customers.count).to eql(2)
      expect(customers.first.first_name).to eql('Danilo')
    end
  end

  describe '.find' do
    it 'returns a Customer' do
      allow(Bigcommerce::Customer).to receive(:find).with(1).and_return(customers.first)

      customer = subject.find(1)
      expect(customer.first_name).to eql('Danilo')
    end
  end

  describe '#orders' do
    it 'loads and returns a list of orders' do
      allow(Bigcommerce::Customer).to receive(:find).with(1).and_return(customers.first)
      allow(Bigcommerce::Order).to receive(:all).with(customer_id: 1).and_return(orders)

      customer = subject.find(1)
      expect(customer.orders.size).to eql(5)
    end
  end
end
