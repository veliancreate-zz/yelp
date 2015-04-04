require 'rails_helper'

def create_restaurant
  click_link 'Add a restaurant'
  fill_in 'Name', with: 'KFC'
  click_button 'Create Restaurant'
end  

feature 'restaurants' do 

  feature 'restaurants logged out' do
    context 'no restaurants have been added' do 
      scenario 'should display a prompt to add a restaurant' do 
        visit '/restaurants'
        expect(page).to have_content 'No restaurants yet'
        expect(page).to have_link 'Add a restaurant'
      end  
    end
    context 'restaurants have been added' do 
      before do 
        Restaurant.create(name: 'KFC')
      end
      scenario 'display restaurants' do 
        visit '/restaurants'
        expect(page).to have_content('KFC')
        expect(page).not_to have_content('No restaurants yet')
      end    
    end
    context 'viewing restaurants' do 
      
      let!(:kfc){Restaurant.create(name:'KFC')}
      scenario 'lets a user view a restaurant' do 
        visit'/restaurants'
        click_link 'KFC'
        expect(page).to have_content 'KFC'
        expect(current_path).to eq "/restaurants/#{kfc.id}"    
      end  
    end  
  end

  feature 'restaurants logged in' do 
    
    before do
      visit('/')
      sign_up('test@test.com', 'testtest', 'testtest')
    end

    context 'creating restaurants' do 
      scenario 'prompts user' do 
        visit '/restaurants'
        create_restaurant
        expect(page).to have_content 'KFC'
        expect(current_path).to eq '/restaurants'
      end  
    end
  
    context 'editing restaurants' do
      
      scenario 'let a user edit a restaurant' do
        visit '/'
        create_restaurant
        click_link 'Edit KFC'
        fill_in 'Name', with: 'Kentucky Fried Chicken'
        click_button 'Update Restaurant'
        expect(page).to have_content 'Kentucky Fried Chicken'
        expect(current_path).to eq '/restaurants'
      end

      scenario "you can't edit a restaurant if you aren't logged in" do 
        visit '/'
        create_restaurant
        click_link 'Sign out'
        click_link 'Edit KFC'
        expect(page).not_to have_content 'Update Restaurant'    
      end

    end

    context 'an invalid restaurant' do
      it 'does not let you submit a name that is too short' do
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'kf'
        click_button 'Create Restaurant'
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end
    end 

    context 'deleting restaurants' do

      before {create_restaurant}

      scenario 'removes a restaurant when a user clicks a delete link' do
        visit '/restaurants'
        click_link 'Delete KFC'
        expect(page).not_to have_content 'KFC'
        expect(page).to have_content 'Restaurant deleted successfully'
      end

      scenario "you cant delete a restaurant if you aren't logged in" do 
        visit '/restaurants'
        click_link 'Sign out'
        click_link 'Delete KFC'
        expect(page).not_to have_content 'KFC'
      end

      scenario "you can't edit a restaurant that you didnt create" do 
        visit '/restaurants'
        click_link('Sign out')
        click_link('Sign up')
        fill_in('Email', with: 'test2@example.com')
        fill_in('Password', with: 'test1test1')
        fill_in('Password confirmation', with: 'test1test1')
        click_button('Sign up')
        click_link 'Edit KFC'
        click_button 'Update Restaurant'
        expect(page).to have_content 'You cant update a restaurant you didnt create'    
      end
      scenario "you can't delete a restaurant that you didnt create" do 
        visit '/restaurants'
        click_link('Sign out')
        click_link('Sign up')
        fill_in('Email', with: 'test_alt@example.com')
        fill_in('Password', with: 'test1test1')
        fill_in('Password confirmation', with: 'test1test1')
        click_button('Sign up')
        click_link 'Delete KFC'
        expect(page).to have_content 'You can only delete restaurants you created'   
      end    
    end 
  end    
end  