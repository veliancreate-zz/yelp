require 'rails_helper'

def leave_review(thoughts, rating)
  visit '/restaurants'
  click_link 'Review KFC'
  fill_in 'Thoughts', with: thoughts
  select rating, from: 'Rating'
  click_button 'Leave Review'
end  

feature 'reviewing' do
  
  before do
    visit('/')
    click_link('Sign up')
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'testtest')
    fill_in('Password confirmation', with: 'testtest')
    click_button('Sign up')
  end

  before {Restaurant.create name: 'KFC'}

  scenario 'allows users to leave a review using a form' do
     visit '/restaurants'
     click_link 'Review KFC'
     fill_in "Thoughts", with: "so so"
     select '3', from: 'Rating'
     click_button 'Leave Review'
     expect(current_path).to eq '/restaurants'
     expect(page).to have_content('so so')
  end

  scenario 'does not allow users to delete a review if they arent logged in' do
    visit '/restaurants'
    leave_review('So so', '3')
    click_link('Sign out')
    click_link('Delete KFC review')
    expect(page).to have_content("You cant delete reviews if you aren't logged in")
  end

  scenario 'does not allow users to delete a review if they didnt create it' do
    visit '/restaurants'
    leave_review('So so', '3')
    click_link('Sign out')
    click_link('Sign up')
    fill_in('Email', with: 'test2@example.com')
    fill_in('Password', with: 'test1test1')
    fill_in('Password confirmation', with: 'test1test1')
    click_button('Sign up')
    click_link('Delete KFC review')
    expect(page).to have_content("You cant delete reviews you didnt create")
  end


  scenario 'displays an average rating for all reviews' do
    leave_review('So so', '3')
    leave_review('Great', '5')
    expect(page).to have_content('Average rating: 4')
  end

end