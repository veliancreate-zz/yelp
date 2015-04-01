class RestaurantsController < ApplicationController
  
  before_action :authenticate_user!, :except => [:index, :show]

  def index
    @restaurants = Restaurant.all
  end  

  def new
    @restaurant = Restaurant.new
  end
  
  def create
    @restaurant = Restaurant.create(options = {:name => restaurant_params[:name], :user_id => current_user.id} )
    if @restaurant.save  
      flash[:notice] = 'Restaurant added successfully'
      redirect_to restaurants_path
    else
      render 'new'
    end    
  end

  def restaurant_params
    params.require(:restaurant).permit(:name)
  end  

  def show
    @restaurant = Restaurant.find(params[:id])
  end  

  def edit
    @restaurant = Restaurant.find(params[:id])
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    if current_user.has_created?(@restaurant)  
      @restaurant.update(restaurant_params)
    else
      flash[:notice] = 'You cant update a restaurant you didnt create'  
    end
    redirect_to '/restaurants'
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    if current_user.has_created?(@restaurant)
      @restaurant.destroy
      flash[:notice] = 'Restaurant deleted successfully'
    else 
      flash[:notice] = 'You can only delete restaurants you created'
    end    
    redirect_to '/restaurants'
  end

end
