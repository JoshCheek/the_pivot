require 'rails_helper'
require 'capybara/rails'
require 'capybara/rspec'

describe 'user', type: :feature do

  before do
    listing = Listing.new
    listing.title                = "Pastry Chef"
    listing.description          = "Kneads the Dough"
    listing.pay_rate             = 35000
    listing.employment_type      = "Full-time"
    listing.number_of_positions  = 2
    listing.closing_date         = Time.now + 1000
    listing.save

    listing.categories.create(title: 'Bakery')

    user = User.new
      user.first_name            = "Jon"
      user.last_name             = "Doe"
      user.email                 = "jd@example.com"
      user.password              = "password"
      user.password_confirmation = "password"
      user.save

    @user = user.id

    page.visit '/signin'
    page.fill_in "session_email", with: "jd@example.com"
    page.fill_in "session_password", with: "password"
    page.click_button "Sign In"
  end

  it 'expects to see a job in their dashboard after applying' do
    visit listings_path
    click_button("Add Job To Cart")
    expect(page).to have_content("Pastry Chef has been added to your cart.")

    click_link("Your Cart")
    # When I click on the button apply
    page.click_link('Apply')
    # and I visit my dashboard page
    page.visit cart_path(@user)
    # I expect to see that job in my dashboard
    expect(page).to have_link("Pastry Chef")
  end
end
