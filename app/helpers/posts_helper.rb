module PostsHelper
    def user_is_authorized_to_edit_post?(post)
        current_user && (current_user == post.user || current_user.admin? || current_user.moderator?)
    end
    
    def user_is_authorized_to_delete_post?(post)
        current_user && (current_user == post.user || current_user.admin?)
    end
end
