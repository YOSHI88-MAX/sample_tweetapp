class PostsController < ApplicationController

    before_action :authenticate_user
    before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}

    def index 
        @posts = Post.all.order(created_at: :desc)
    end 

    def show 
        @post = Post.find_by(id: params[:id])
        @user = @post.user
        @likes_count = Like.where(post_id: @post.id).count
    end 

    def new 
        @post= Post.new
    end 

    def create 
        @post= Post.new(content: params[:content], user_id: @current_user.id)

        if @post.save
            flash[:notice]= "選手のハートに火が付きました。しゅぽっ。"
            redirect_to("/posts/index")
        else
            render("posts/new")
        end
    end 
     
    def edit
        @post= Post.find_by(id: params[:id])
    end

    def update 
        @post= Post.find_by(id: params[:id])
        @post.content= params[:content]
        if @post.save
        flash[:notice]= "選手のハートの火がさらに燃え盛っています。ごぉぉ。"
        redirect_to("/posts/index")
        else 
        render("posts/edit")
        end 
    end 

    def destroy
        @post= Post.find_by(id: params[:id])
        @post.destroy
        flash[:notice]= "応援をやっぱやーめた。"
        redirect_to("/posts/index")
    end 
   
    def ensure_correct_user
        @post = Post.find_by(id: params[:id])
        if @post.user_id != @current_user.id
        flash[:notice]= "今のあなたには不可能です。精進なさい。"
        redirect_to("/posts/index")
        end 
    end 

end 

