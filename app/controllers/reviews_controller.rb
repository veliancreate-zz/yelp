class ReviewsController < ApplicationController

  def new
    console
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    if current_user.has_reviewed? @restaurant
      flash[:notice] = 'You can only write one review per restaurant'        
      redirect_to restaurants_path
    else
      @restaurant.reviews.create(options = {:thoughts => review_params[:thoughts], :rating => review_params[:rating], :user_id => current_user.id} )
      redirect_to restaurants_path
    end  
  end

  def review_params
    params.require(:review).permit(:thoughts, :rating)
  end  

end