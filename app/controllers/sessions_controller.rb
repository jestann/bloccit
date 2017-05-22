class SessionsController < ApplicationController
    
    def new
        # so nothing is here because no session model?
        # at some point doesn't it have to assign an email and
        # password to session?
        # the session doesn't persist in the database
        # but doesn't it have to be defined somewhere for
        # it to show up in params?
    end
    
    def create
        user = User.find_by(email: params[:session][:email].downcase)
        # so does an object called "session" occur naturally in
        # params even without a sessions model?
        # a "session" object is created in params hash simply
        # by running a create method from sessions_controller?
        # and where does it know to find :email and :password for it?
        
        if user && user.authenticate(params[:session][:password])
            # where does the method user.authenticate come from?
            create_session(user)
            flash[:notice] = "Welcome, #{user.name}!"
            redirect_to root_path
        else
            flash.now[:alert] = "Invalid email/password combination."
            render :new
        end
    end
    
    # so routes have more to do with controllers/views than models right?
    # and you can kind of just use "session" objects if there
    # is a "sessions_controller"?
    # why the different pluralities in rake routes?
    
    def destroy
        destroy_session(current_user)
        # so is there a reason to not just say
        # session[:user_id] = user.id or params[:user][:id] here?
        # can you have a "session" with properties without a 
        # session declaration or creation somewhere?
        flash[:notice] = "You've been signed out. Come back soon!"
        redirect_to root_path
    end
    
end
