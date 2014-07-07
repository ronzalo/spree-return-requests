class Spree::ReturnRequestLineItem < ActiveRecord::Base
  belongs_to :return_request
  belongs_to :line_item

  validates :qty, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    message: Spree.t('validation.must_be_int')
  }

  validate :not_returning_more_than_ordered

  def name_and_sku
    line_item ? line_item.variant.name_and_sku : ""
  end

  def options_text
    line_item ? line_item.variant.options_text : ""
  end

  def returnable_qty
    qty_ordered - qty_already_returned
  end

  def qty_already_returned
    # TODO: also consider Return Authorizations, not just Return Requests
    # TODO: make sure it only considers approved RAs and RRs
    already_returned = 0
    if return_request

      return_requests = Spree::ReturnRequest.for_order_id(return_request.order_id).reject do |rr|
        # don't consider return requests that were denied or not yet submitted
        rr.submitted_at == nil || rr.status == "denied"
      end

      return_requests.each do |rr|
        rr.line_items.each do |li|
          if li.line_item_id == self.line_item_id
            already_returned += li.qty
          end
        end
      end
    end
    already_returned
  end

  def qty_ordered
    line_item ? line_item.quantity : 0
  end

  def dump
    puts "line_item_id: #{self.line_item_id}\t qty: #{self.qty}"
  end

  private

    def not_returning_more_than_ordered
      errors.add(:qty, Spree.t(:not_returning_more_than_ordered)) if qty > returnable_qty
    end
end
