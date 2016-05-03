# Stripe
#
# Create a charge {{{
#
# 1. credit card => stripe token
#

require "stripe"
Stripe.api_key = "sk_test_BQokikJOvBiI2HlWgH4olfQ2"

token = Stripe::Token.create(
  card: {
    number:    "4242424242424242",
    exp_month: 4,
    exp_year:  2017,
    cvc:       "314"
  },
)

token

# 2. charge!

# charge = Stripe::Charge.create(
#   amount:      400,    # US$ 4 (400 cents)
#   currency:    "usd",
#   source:      token.id,
#   description: "Charge for a t-shirt"
# )
# p charge

# Stripe token can be used only once!
# So, how do we e.g. charge periodically..?
# Or store customer data so she doesn't have to enter CC data each time

# }}}
# Store a token as a customer {{{

token # created above

# 3. token => customer

customer = Stripe::Customer.create(
  source:      token,
  description: "ruby@troller.com",
  metadata: {
    foo: "bar"
  }
)

# store this id
p customer.id

charge2 = Stripe::Charge.create(
  amount:      400,    # US$ 4 (400 cents)
  currency:    "usd",
  customer:      customer.id,
  description: "Charge for a t-shirt"
)
charge2

# }}}
# Plans and subscriptions {{{

# create a plan
plan = Stripe::Plan.create(
  amount:   500,
  interval: "year",
  name:     "Amazing Gold Plan",
  currency: "usd",
  id:       "gold"
)


# create a subscription
# plans are identified by their name
customer.update_subscription(plan: "gold")
# or
# customer.subscriptions.create(plan: "gold")

# }}}

# vim: fdm=marker
