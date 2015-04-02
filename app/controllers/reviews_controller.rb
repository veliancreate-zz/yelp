class ReviewsController < ApplicationController

  def new
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
    console  
    redirect_to restaurants_path
  end

  def review_params
    params.require(:review).permit(:thoughts, :rating)
  end  

  def destroy
    @review = Review.find(params[:id])
    if current_user
      if @review.user_id == current_user.id
        @review.destroy
        flash[:notice] = "Review deleted"
      else
        flash[:notice] = "You cant delete reviews you didnt create"
      end
    else
      flash[:notice] = "You cant delete reviews if you aren't logged in"
    end    
    redirect_to restaurants_path
  end  

end