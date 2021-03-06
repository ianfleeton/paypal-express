require 'spec_helper.rb'

describe Paypal::Payment::Request do
  let :instant_request do
    Paypal::Payment::Request.new(
      amount: BigDecimal('25.7'),
      tax_amount: BigDecimal('0.4'),
      shipping_amount: BigDecimal('1.5'),
      :currency_code => :JPY,
      :description => 'Instant Payment Request',
      :notify_url => 'http://merchant.example.com/notify',
      :invoice_number => 'ABC123',
      :custom => 'Custom',
      :items => [{
        :quantity => 2,
        :name => 'Item1',
        :description => 'Awesome Item 1!',
        :amount => BigDecimal("10.25")
      }, {
        :quantity => 3,
        :name => 'Item2',
        :description => 'Awesome Item 2!',
        amount: BigDecimal('1.1')
      }],
      :custom_fields => {
        "l_surveychoice{n}" => 'abcd' # The '{n}' will be replaced with the index
      }
    )
  end

  let :recurring_request do
    Paypal::Payment::Request.new(
      :currency_code => :JPY,
      :billing_type => :RecurringPayments,
      :billing_agreement_description => 'Recurring Payment Request'
    )
  end

  let :reference_transaction_request do
    Paypal::Payment::Request.new(
      :currency_code => :JPY,
      :billing_type => :MerchantInitiatedBillingSingleAgreement,
      :billing_agreement_description => 'Reference Transaction Request'
    )
  end

  describe '.new' do
    it 'should handle Instant Payment parameters' do
      expect(instant_request.amount.total).to eq(BigDecimal('25.7'))
      expect(instant_request.amount.tax).to eq(BigDecimal('0.4'))
      expect(instant_request.amount.shipping).to eq(BigDecimal('1.5'))
      expect(instant_request.currency_code).to eq(:JPY)
      expect(instant_request.description).to eq('Instant Payment Request')
      expect(instant_request.notify_url).to eq('http://merchant.example.com/notify')
    end

    it 'should handle Recurring Payment parameters' do
      expect(recurring_request.currency_code).to eq(:JPY)
      expect(recurring_request.billing_type).to eq(:RecurringPayments)
      expect(recurring_request.billing_agreement_description).to eq('Recurring Payment Request')
    end

    it 'should handle Recurring Payment parameters' do
      expect(reference_transaction_request.currency_code).to eq(:JPY)
      expect(reference_transaction_request.billing_type).to eq(:MerchantInitiatedBillingSingleAgreement)
      expect(reference_transaction_request.billing_agreement_description).to eq('Reference Transaction Request')
    end
  end

  describe '#to_params' do
    it 'should handle Instant Payment parameters' do
      expect(instant_request.to_params).to eq({
        :PAYMENTREQUEST_0_AMT => "25.70",
        :PAYMENTREQUEST_0_TAXAMT => "0.40",
        :PAYMENTREQUEST_0_SHIPPINGAMT => "1.50",
        :PAYMENTREQUEST_0_CURRENCYCODE => :JPY,
        :PAYMENTREQUEST_0_DESC => "Instant Payment Request",
        :PAYMENTREQUEST_0_NOTIFYURL => "http://merchant.example.com/notify",
        :PAYMENTREQUEST_0_ITEMAMT => "23.80",
        :PAYMENTREQUEST_0_INVNUM => "ABC123",
        :PAYMENTREQUEST_0_CUSTOM => "Custom",
        :L_PAYMENTREQUEST_0_NAME0 => "Item1",
        :L_PAYMENTREQUEST_0_DESC0 => "Awesome Item 1!",
        :L_PAYMENTREQUEST_0_AMT0 => "10.25",
        :L_PAYMENTREQUEST_0_QTY0 => 2,
        :L_PAYMENTREQUEST_0_NAME1 => "Item2",
        :L_PAYMENTREQUEST_0_DESC1 => "Awesome Item 2!",
        :L_PAYMENTREQUEST_0_AMT1 => "1.10",
        :L_PAYMENTREQUEST_0_QTY1 => 3,
        :L_SURVEYCHOICE0 => 'abcd' # Note the 'n' was replaced by the index
      })
    end

    it 'should handle Recurring Payment parameters' do
      expect(recurring_request.to_params).to eq({
        :PAYMENTREQUEST_0_AMT => "0.00",
        :PAYMENTREQUEST_0_TAXAMT => "0.00",
        :PAYMENTREQUEST_0_SHIPPINGAMT => "0.00",
        :PAYMENTREQUEST_0_CURRENCYCODE => :JPY,
        :L_BILLINGTYPE0 => :RecurringPayments,
        :L_BILLINGAGREEMENTDESCRIPTION0 => "Recurring Payment Request"
      })
    end

    it 'should handle Reference Transactions parameters' do
      expect(reference_transaction_request.to_params).to eq({
        :PAYMENTREQUEST_0_AMT => "0.00",
        :PAYMENTREQUEST_0_TAXAMT => "0.00",
        :PAYMENTREQUEST_0_SHIPPINGAMT => "0.00",
        :PAYMENTREQUEST_0_CURRENCYCODE => :JPY,
        :L_BILLINGTYPE0 => :MerchantInitiatedBillingSingleAgreement,
        :L_BILLINGAGREEMENTDESCRIPTION0 => "Reference Transaction Request"
      })
    end
  end

  describe '#items_amount' do
    let(:instance) do
      Paypal::Payment::Request.new(
        :items => [{
          :quantity => 3,
          :name => 'Item1',
          :description => 'Awesome Item 1!',
          :amount => BigDecimal("130.45")
        }]
      )
    end

    # NOTE: with floats,
    # 130.45 * 3 => 391.34999999999997 (in ruby 1.9)
    it 'should calculate total amount correctly' do
      expect(instance.items_amount).to eq(BigDecimal('391.35'))
    end
  end
end
