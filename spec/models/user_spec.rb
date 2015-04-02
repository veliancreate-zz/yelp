require 'rails_helper'

describe User, :type => :model do

  it { is_expected.to have_many :restaurants }

  it { is_expected.to have_many :reviews }

  it { is_expected.to have_many :reviewed_restaurants}

  it 'knows if a user created a restaurant' do 
    user = User.create(email: "anothertest@test.com", password: "testtest")
    restaurant = Restaurant.create(name: "Burger Queen", user: user)
    expect(user.has_created?(restaurant)).to eq(true)  
  end  

  it 'knows if a user has reviewed a restaurant' do 
    user = User.create(email: "testtesttest@test.com", password: "testtesttest")
    restaurant = Restaurant.create(name: "MacDonalds", user: user)
    restaurant.reviews.create(thoughts: "Great!", rating: 5, user: user)
    expect(user.has_reviewed?(restaurant)).to eq(true)
  end  

end