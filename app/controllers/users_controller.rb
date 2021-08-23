class UsersController < ApplicationController
    # before_action :authenticate_user, {only: [:index, :show, :edit, :update]}
    # before_action :forbid_login_user, {only: [:new, :create, :login_form, :login]}
    # before_action :ensure_correct_user, {only: [:edit, :update]}

    before_action :authenticate_user, only: [:index, :show, :edit, :update]
    before_action :forbid_login_user, only: [:new, :create, :login_form, :login]
    before_action :ensure_correct_user, only: [:edit, :update]
     
    def index 
        @users= User.all
    end 

    def show 
        @user= User.find_by(id: params[:id])
    end 

    def new 
        @user = User.new
    end


   # @userの情報がしっかり登録できていない可能性 @userが生成されていない
    def create 
        
        @user = User.new(
            name: params[:name],
            email: params[:email],
            image_name: "IMG_5080.JPG",
            password: params[:password]
        )
        if @user.save
            session[:user_id] = @user.id
            flash[:notice]= "パワーの源入りました。どすこい。"
            redirect_to("/users/#{@user.id}")
        else
            render("users/new")
        end 
    end 

    def edit 
        @user = User.find_by(id: params[:id])
    end


    def update 
        @user= User.find_by(id: params[:id])
  
        @user.name= params[:name]
        @user.email= params[:email]
        if params[:image]
            @user.image_name = "#{@user.id}.jpg"
            image = params[:image]
            File.binwrite("public/#{@user.image_name}", image.read)
        end 

        # 写真を編集から変更する場合に、写真をid番号に変換してuser.image_nameに入れられる
        # その後、file binwriteによってpublicの中にid 番号の写真として自動保存される

        if @user.save
            flash[:notice]= "パワーの源に磨きがかかりました"
            redirect_to("/users/#{@user.id}")
        else
            render("users/edit")
        end 
    end 

    def login_form
    end 

    def login
        @user= User.find_by(email: params[:email])
        if @user && @user.authenticate(params[:password])
            session[:user_id]= @user.id
            flash[:notice]= "ログインしました"
            redirect_to("/posts/index")
        else
            @error_message= "メールアドレスまたはパスワードが間違っています"
            @email= params[:email]
            @password= params[:password]
            render("users/login_form")
        end 
    end

      def logout 
        session[:user_id]= nil 
        flash[:notice]= "ログアウトしました"
        redirect_to("/login")
      end 

      def likes 
        @user= User.find_by(id: params[:id])
        @likes= Like.where(user_id: @user.id)
      end 

      def ensure_correct_user
        if @current_user.id != params[:id].to_i
            flash[:notice]= "今のあなたには不可能です。精進なさい。"
            redirect_to("/posts/index")
        end
    end 


end 


#新規登録できなかった原因
# before_actionは、後に続く指示の前に必ずbefore_actionの項目を呼び出すよという意味
# def show を行うときにbefore_action: authenticate_userでshowを制限しているため、application_controllerのdef authenticate_userに行く
#     このときに、if @current_user == nilと指定してあるため、flash[:notice]="ログインが必要です"に行ってしまい、ログイン画面に誘導されていた。
#     before_action: set_current_userを設定することによって、set_current_userを先に呼び出すようになるよ



# <%= image_tag "profile.jpg", class: "unko" %> 
# <%# class以下で名前を設定して、それをscssに持っていってサイズなどを調整する%>



#エラーに関しての検証方法
# binding.pryを検証したい該当箇所に書くコード
# binding.pryは処理を止めるので、その後の箇所をターミナルでコマンドを随時打ってチェック
# エラー箇所に関しては、inspectを使って、その後にurlからrouting チェック、コード該当箇所に行きコード変更 scssに関しても同じ流れで、scssのタイトルと照らし合わせて変更していく

#写真の保存場所
# image_tagを使った方が、写真を導入するにはポピュラー 写真はpublicに保存されているためimage_tagはpublic用の書き方で

# zenkakuの使用法
# command + shift + p でコマンドパレットを開き、そこでenable zenkakuで全角をチェックできる

# 投稿画面のindexから、posts/:id の投稿詳細に行けない問題の解決方法について
# zenkakuのvscode 拡張機能を使って ファイルを全て点検した結果、全角の部分がありその部分を消したら投稿詳細画面に侵入できた

#pg 1.2.3をインストールし、bundle installできない
#env ARCHFLAGS="-arch x86_64" gem install pg このコマンド、環境変数を用いてpath を示してあげる

#環境的問題 問題例 以下 関係ファイル：gemfile, gemlock
# remote:  !
# remote:  !     Failed to install gems via Bundler.
# remote:  !
# remote:  !     Push rejected, failed to compile Ruby app.
# remote: 
# remote:  !     Push failed
# remote: Verifying deploy...
# remote: 
# remote: !       Push rejected to sample77tweetapp.
# remote: 
# To https://git.heroku.com/sample77tweetapp.git
#  ! [remote rejected] master -> master (pre-receive hook declined)
# error: failed to push some refs to 'https://git.heroku.com/sample77tweetapp.git'

#上記解決方法

# Yoshihiros-MacBook-Pro:sample_tweetapp yoshi$ bundler -v
# Bundler version 2.2.26
# Yoshihiros-MacBook-Pro:sample_tweetapp yoshi$ bundle lock --add-platform x86_64-linux
# Fetching gem metadata from https://rubygems.org/............
# Resolving dependencies.........
# Writing lockfile to /Users/yoshi/sample_tweetapp/Gemfile.lock
# Yoshihiros-MacBook-Pro:sample_tweetapp yoshi$ bundler -v
# Bundler version 2.2.26
# Yoshihiros-MacBook-Pro:sample_tweetapp yoshi$ bundle _2.2.21_ install

# Yoshihiros-MacBook-Pro:sample_tweetapp yoshi$ bundler -v
# Bundler version 2.2.26
# Yoshihiros-MacBook-Pro:sample_tweetapp yoshi$ bundler -v
# Bundler version 2.2.26
# Yoshihiros-MacBook-Pro:sample_tweetapp yoshi$ bundle _2.2.21_ install

# Yoshihiros-MacBook-Pro:sample_tweetapp yoshi$ bundler -v
# Bundler version 2.2.21
# Yoshihiros-MacBook-Pro:sample_tweetapp yoshi$ git add .
# Yoshihiros-MacBook-Pro:sample_tweetapp yoshi$ git commit -m "fix"
# [master b168a19] fix
#  Committer: Yoshi <yoshi@Yoshihiros-MacBook-Pro.local>
# Your name and email address were configured automatically based
# on your username and hostname. Please check that they are accurate.
# You can suppress this message by setting them explicitly. Run the
# following command and follow the instructions in your editor to edit
# your configuration file:

#     git config --global --edit

# After doing this, you may fix the identity used for this commit with:

#     git commit --amend --reset-author

#  1 file changed, 4 insertions(+), 1 deletion(-)
# Yoshihiros-MacBook-Pro:sample_tweetapp yoshi$ git status
# On branch master
# Your branch is ahead of 'origin/master' by 2 commits.
#   (use "git push" to publish your local commits)

# nothing to commit, working tree clean
# Yoshihiros-MacBook-Pro:sample_tweetapp yoshi$ git push heroku master

# sqlite3でweb applicationを作り始めたから、herokuにローカルからリモートへあげるときのpush時にpostgresql に変換しなければならず
# gemfileの変更内容を、gemlockの確定バージョンにしてpushするため、確定情報はadd, commit, pushの手順であげる

# applicationを作る時に、まず日本語でこの機能が欲しいみたいな感じで組み立てていく。
#   ex この画面にはユーザーの一覧を作りたい、その時にどうすれば良いか '7つのaction(controller)' → ユーザー全部を取得する必要がありそう⇨ データベースからユーザー全部を引っ張ってくる必要がある 

#deployした後にローカルで変更した内容
# git add. git commit, git push heroku master で反映しないと行けない

# github ローカルの内容をアップデートする
# 参考URL :   https://qiita.com/sayama0402/items/9afbb519d97327b9f05c
# 参考URL : https://atmarkit.itmedia.co.jp/ait/articles/1701/24/news141_3.html
