module SessionsHelper
    def create_session(user)
        session[:user_id] = user.id
        # where do you get "user" from in sessions_helper?
        # does it just know to draw from params[:user]?
        
        # ANSWER: it gets passed in as a parameter, duh
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
        
        # ANSWER: yes, this module is where the actual session
        # object provided by rails is accessed. It is just a 
        # "local storage" hash available, so we create a
        # user_id symbol and store the user.id in it here
        
        # It's best practice to abstract out actual interaction
        # with the rails session object here and only make it
        # accessible to regular controllers by methods
        
        # So in the end there are two session objects. One is just a name
        # for a set of parameters in the params hash, created by form_for
        # And the other is this one, the actual rails session object.
        # Meanwhile, the controller doesn't actually know about either,
        # just maps routes to actions/methods like all controllers do!
    end
end
