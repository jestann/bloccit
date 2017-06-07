class FavoriteMailer < ApplicationMailer
    default from: "jessannbird@gmail.com"
    
    def new_comment(user, post, comment)
        headers["Message-ID"] = "<comments/#{comment.id}@jess-bloccit-app.herokuapp.com>"
        headers["In-Reply-To"] = "<post/#{post.id}@jess-bloccit-app.herokuapp.com>"
        headers["References"] = "<post/#{post.id}@jess-bloccit-app.herokuapp.com>"
        
        @user = user
        @post = post
        @comment = comment
        
        mail(to: user.email, subject: "New comment on #{post.title}")
    end
    
    def new_post(user, post)
        headers["Message-ID"] = "<post/#{post.id}@jess-bloccit-app.herokuapp.com>"
        headers["In-Reply-To"] = "<post/#{post.id}@jess-bloccit-app.herokuapp.com>"
        headers["References"] = "<post/#{post.id}@jess-bloccit-app.herokuapp.com>"
        
        @user = user
        @post = post
        
        mail(to: user.email, subject: "You just created a post: #{post.title}")
    end
end
