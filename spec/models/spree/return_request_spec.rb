require 'spec_helper'

describe Spree::ReturnRequest do

  it "has a valid factory" do
    FactoryGirl.build(:spree_return_request).should be_valid
  end

  it "requires an order id" do
    FactoryGirl.build(:spree_return_request, order_id: nil).should_not be_valid
  end

  it "requires an email address" do
    FactoryGirl.build(:spree_return_request, email_address: nil).should_not be_valid
  end

  describe "upon save" do
    it "requires the email address is associated with the order" do
      order = FactoryGirl.create(:shipped_order)
      return_request = Spree::ReturnRequest.new(order: order, email_address: "notright@spree.com")
      expect { return_request.save! }.to raise_error
    end

    it "requires the order be younger than a configurable number of days" do
      SpreeReturnRequests::Config[:return_request_max_order_age_in_days] = 30
      order = FactoryGirl.create(:shipped_order, completed_at: 31.days.ago)
      return_request = Spree::ReturnRequest.new(order: order, email_address: order.email)
      expect { return_request.save! }.to raise_error
    end
  end

  describe "line items allowed to be returned" do

    context "when no previous returns placed against order" do

      before do
        @order = FactoryGirl.create(:shipped_order)
        @return_request = Spree::ReturnRequest.new(order: @order, email_address: @order.email)
      end

      it "should allow the same line items (and their quantities) as the order" do
        @order.line_items.should == @return_request.returnable_line_items
      end
    end

    context "when one previous return was placed against the order" do

      before do
        @order = FactoryGirl.create(:shipped_order)
        @return_request = Spree::ReturnRequest.create!(order: @order, email_address: @order.email)
      end

      it "should consider the one previous return"
    end
    context "when two previous returns were placed against the order" do
      it "should consider the two previous returns"
    end
  end
end
