require 'rails_helper'

describe Review, :type => :model do
  it "is invalid if the rating is more than 5" do
    review = Review.new(rating: 10)
    expect(review).to have(1).error_on(:rating)
  end
  
  it "A review is associated to a restaurant" do
    restaurant = Restaurant.create(name: "Moe's Tavern")
    review = restaurant.reviews.create(thoughts: "Amazing", rating: 3)
    expect(review.restaurant).to eq(restaurant)
  end

end