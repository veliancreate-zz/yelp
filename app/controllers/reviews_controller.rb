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
    else
      @restaurant.create_review(review_params, current_user)
    end  
    redirect_to restaurants_path
  end

  def review_params
    params.require(:review).permit(:thoughts, :rating)
  end  

end