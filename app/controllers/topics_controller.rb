class TopicsController < ApplicationController
    before_action :require_sign_in, except: [:index, :show]
    before_action :allow_moderator, except: [:index, :show, :new, :create, :delete]
    before_action :authorize_user, except: [:index, :show, :edit, :update]
    
    def index
        @topics = Topic.all
    end
    
    def show
        @topic = Topic.find(params[:id])
    end
    
    def new
        @topic = Topic.new
    end
    
    def create
        @topic = Topic.new(topic_params)
        
        # OLD WAY
        # @topic = Topic.new
        # @topic.name = params[:topic][:name]
        # @topic.description = params[:topic][:description]
        # @topic.public = params[:topic][:public]
        
        if @topic.save
            # why this different syntax here from usual?
            redirect_to @topic, notice: "Topic was saved successfully."
        else
            flash.now[:alert] = "Error creating topic. Please try again."
            render :new
        end
    end
    
    def edit
        @topic = Topic.find(params[:id])
    end
    
    def update
        @topic = Topic.find(params[:id])
        @topic.assign_attributes(topic_params)
        
        # OLD WAY
        # @topic.name = params[:topic][:name]
        # @topic.description = params[:topic][:description]
        # @topic.public = params[:topic][:public]
        
        if @topic.save
            flash[:notice] = "Topic was updated."
            redirect_to @topic
        else
            flash.now[:alert] = "Error saving topic. Please try again."
            render :edit
        end
    end
    
    def destroy
        @topic = Topic.find(params[:id])
        
        if @topic.destroy
            flash[:notice] = "\"#{@topic.name}\" was deleted successfully."
            redirect_to action: :index
            # this is the same as redirect_to topics_path, since resourceful
            # routing routes topics_path to the index action
        else
            flash.now[:alert] = "There was an error deleting the topic."
            render :show
        end
    end
    
    private
    def topic_params
        params.require(:topic).permit(:name, :description, :public)
    end
    
    def allow_moderator
        unless current_user.moderator? || current_user.admin?
            flash[:alert] = "You must be an admin or a moderator to do that."
            redirect_to topics_path
        end
    end

    def authorize_user
        unless current_user.admin?
            flash[:alert] = "You must be an admin to do that."
            redirect_to topics_path
        end
    end
end
