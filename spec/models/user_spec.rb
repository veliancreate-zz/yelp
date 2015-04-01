require 'rails_helper'

describe User, :type => :model do

  it { is_expected.to have_many :restaurants }

  it { is_expected.to have_many :reviews }

  it { is_expected.to have_many :reviewed_restaurants}

  it 'knows if a user created a restaurant' do 
    user = User.new(id: 1)
    restaurant = Restaurant.new(user_id: 1)
    expect(user.has_created?(restaurant)).to eq(true)  
  end  

  it 'knows if a user has reviewed a restaurant' do 
    user = User.new(id: 1)
    restaurant = Restaurant.new(user_id: 1)
    restaurant.reviews = [Review.new({thoughts: "Great!", rating: 5, user_id: 1})]
    expect(user.has_reviewed?(restaurant)).to eq(true)
  end  

end