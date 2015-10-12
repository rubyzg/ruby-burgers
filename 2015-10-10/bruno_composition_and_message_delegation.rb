# Composition and message delegation
# Composition {{{
# The best way to manage complex logic in the object oriented way.
#
# Problem:
# - objects with too many methods
# - in rails: god objects, god models
#
# Solution(s):
# - view models (draper gem)
# - module inclusion
# - rails concerns
# - service objects
# - composed (service) objects **
# }}}
# Composition example {{{
# Example active record model with some existing logic

class Order < ActiveRecord::Base

  has_many :transactions # money transactions, transaction_types: "charge" or "refund"

  def good_sam_membership_purchased?
  end

  def signature_type
  end

  def submitter
  end

  def add_errors
  end

  def ever_charged_credit_card?
  end

  def valid_payment_profile
  end

  def transaction_logic
  end

end

# new feature request: calculate the total payment made.

# New methods:

def total
  all_charges.sum(:amount_cents) - all_refunds.sum(:amount_cents)
end

private

def all_charges
  order.transactions.where(transaction_type: "charge")
end

def all_refunds
  order.transactions.where(transaction_type: "refund")
end

# Question: what object do we put these methods on?
# - Order model? NO!
# - service class? yea, kinda..
# - composed class? YES!

# service object solution {{{

# app/services/order_payments.rb
class OrderPayments

  def initialize(order) # note we're passing order to this class
    @order = order
  end

  def total
  end

  private

  def order
    @order
  end

  def all_charges
  end

  def all_refunds
  end

end

# usage:

# app/controllers/orders_controller.rb
class OrdersController < ApplicationController

  def show
    @order = Order.find(params[:id])
    @total = OrderPayments.new(@order).total
  end

end

# this is a good solution

# small downsides:
# - spams controller
# - spams global constant namespace

# }}}
# composition solution {{{

# lib/order/payments.rb
class Order
  class Payments

    def initialize(order)
      @order = order
    end

    def total
    end

    private

    def order
      @order
    end

    def all_charges
      order.nesto
    end

    def all_refunds
      order.nesto2
    end

  end
end

# composition version 1

class Order < ActiveRecord::Base

  # composition here
  def payments
    Payments.new(self)
  end

end

# composition version 2 (improved)

class Order < ActiveRecord::Base

  # composition improved with memoization
  def payments
    @payments ||= Payments.new(self)
  end

end

# usage in view

# <div class="order-total">
#   <%= @order.payments.total %> # breaking the Law of Demeter
# </div>

# }}}
# }}}
# Delegation {{{
# Problem: message chaining is not scalable.

# <div class="order-total">
#   <%= order.payments.statistics.endpoint %> # trainwreck
# </div>

# Solution: delegation!

# version 1

class Order < ActiveRecord::Base

  def total
    payments.total
  end

  private

  # composition improved with memoization
  def payments
    @payments ||= Payments.new(self)
  end

end

# improved, final version

class Order < ActiveRecord::Base

  delegate :total, to: :payments

  private

  # composition improved with memoization
  def payments
    @payments ||= Payments.new(self)
  end

end

# }}}
# Conclusion {{{

# Composition + delegation
# - scalable
# - elegant
# - pure object oriented way (no rails fluff)

# }}}
# vim: fdm=marker
