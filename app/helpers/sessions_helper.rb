module SessionsHelper
    def create_session(user)
        session[:user_id] = user.id
        # where do you get "user" from in sessions_helper?
        # does it just know to draw from params[:user]?
        # it gets passed in as a parameter
    end
    
    def destroy_session(user)
        session[:user_id] = nil
    end
    
    def current_user
        User.find_by(id: session[:user_id])
        # apparently session also has a user_id
        # where does that get declared or set?
        # and then current_user can just be used wherever?
        # and it has access to "session" just floating out
        # there in the void?
    end
end
