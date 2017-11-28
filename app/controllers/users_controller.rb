class UsersController < ApplicationController
    
    def new
        @user = User.new
    end

    def create
        @user = User.new
        @user.name = params[:user][:name]
        @user.email = params[:user][:email]
        @user.password = params[:user][:password]
        @user.password_confirmation = params[:user][:password_confirmation]
        
        if @user.save
            flash[:notice] = "Welcome to Rereadit #{@user.name}!"
            create_session(@user)
            # why this order?
            redirect_to root_path
        else
            flash.now[:alert] = "There was an error creating your account. Please try again."
            render :new
        end
    end
    
    def show
        @user = User.find(params[:id])
        @posts = @user.posts.visible_to(current_user)
        # this scopes posts to only show public topic posts if the user isn't signed in
    end

end
