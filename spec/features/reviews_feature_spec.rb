require 'rails_helper'

def leave_review(thoughts, rating)
  visit '/restaurants'
  click_link 'Review KFC'
  fill_in 'Thoughts', with: thoughts
  select rating, from: 'Rating'
  click_button 'Leave Review'
end  

def sign_up(email, pword, pword_conf )
  visit('/')
  click_link('Sign up')
  fill_in('Email', with: email)
  fill_in('Password', with: 'testtest')
  fill_in('Password confirmation', with: 'testtest')
  click_button('Sign up')  
end  

feature 'reviewing' do
  
  before do
    sign_up('test@test.com', 'testtest', 'testtest')
  end

  before {Restaurant.create name: 'KFC'}

  scenario 'allows users to leave a review using a form' do
     visit '/'
     leave_review('so so', '3')
     expect(current_path).to eq '/restaurants'
     expect(page).to have_content('so so')
  end

  scenario 'does not allow users to delete a review if they arent logged in' do
    visit '/'
    leave_review('so so', '3')
    click_link('Sign out')
    click_link('Delete KFC review')
    expect(page).to have_content("You cant delete reviews if you aren't logged in")
  end

  scenario 'does not allow users to delete a review if they didnt create it' do
    visit '/restaurants'
    leave_review('So so', '3')
    click_link('Sign out')
    sign_up('test1@testtest.com', 'testtest', 'testtest')
    click_link('Delete KFC review')
    expect(page).to have_content("You cant delete reviews you didnt create")
  end

  scenario 'displays an average rating for all reviews' do
    leave_review('So so', '3')
    visit '/restaurants'
    click_link('Sign out')
    sign_up('test2@testtest.com', 'testtest', 'testtest') 
    leave_review('Great', '5')
    expect(page).to have_content('Average rating: 4')
  end

end