# This is the main router file
# You can also create your own controllers in app/controllers/

module Honeybadger

  class SiteApp < Padrino::Application

    register Padrino::Mailer
    register Padrino::Helpers
    register WillPaginate::Sinatra
    enable :sessions
    enable :reload
    layout :user_layout


    ### this runs before all routes ###
    before do
      @title = "Honeybadger CMS"
      @page = (params[:page] || 1).to_i
      @per_page = params[:per_page] || 5
    end      

    ### authentication routes ###
    auth_keys = settings.auth # @todo: settings is not available in Builder

    use OmniAuth::Builder do

      # /auth/twitter
      provider :twitter,  auth_keys[:twitter][:key], auth_keys[:twitter][:secret]

      # /auth/instagram
      provider :instagram,  auth_keys[:instagram][:key], auth_keys[:instagram][:secret]

    end

    get '/auth/:name/callback' do
      auth    = request.env["omniauth.auth"]
      user = User.login_with_omniauth(auth)

      if user
        session[:user] = user

        if user.email.blank?
          redirect("/user/account", :notice => 'Please fill in required informations')
        end

        redirect("/")
      else
        output(user.values)
      end
    end

    get "/user/account" do
      @user = session[:user]
      render "account"
    end

    post "/user/account" do

      rules = {
        :email => {:type => 'email', :required => true},
        :first_name => {:type => 'string', :required => true},
        :last_name => {:type => 'string', :required => true},
      }
      validator = Validator.new(params, rules)

      @user = session[:user]
      @user.email = params[:email]
      @user.first_name = params[:first_name]
      @user.last_name = params[:last_name]
      @user.username = params[:username]
      @user.gender = params[:gender]
      @user.occupation = params[:occupation]
      @user.immigration = params[:immigration]
      @user.birth_month = params[:birth_month]
      @user.birth_day = params[:birth_day]
      @user.birth_year = params[:birth_year]
      @user.self_summary = params[:self_summary]
      @user.language = params[:language]
      @user.zip = params[:zip]
      if params[:picture]
        filename = params[:picture][:filename]
        tempfile = params[:picture][:tempfile]
        target = "/images/#{filename}"
        local_dest = Dir.pwd + "/public" + target

        FileUtils.mv(tempfile.path, local_dest)
        temp_pic = Picture.where(:user_id => params[:user_id]).first
        if temp_pic == nil
          picture = Picture.new(:user_id => params[:user_id], :image_url => target, :main_pic => "true")
          @user.have_pic = true
          picture.save
        else
          picture = Picture.new(:user_id => params[:user_id], :image_url => target, :main_pic => "false")
          @user.have_pic = true
          picture.save
        end

      end


      if !validator.valid?
        flash.now[:notice] = validator.errors[0][:error]
        render "account"
      else
        @user.save_changes
        redirect("/user/account", :success => 'Account information updated!')
      end

    end

    get "/user/login" do
      render "login"
    end

    post "/user/login" do

      rules = {
        :email => {:type => 'email', :required => true},
        :password => {:type => 'string', :required => true},
      }
      validator = Validator.new(params, rules)
      if !validator.valid?
        flash.now[:notice] = validator.errors[0][:error]
        render "login"
      else
        user = User.login(params)
        if user.errors.empty?
          session[:user] = user
          flash[:success] = "You are now logged in"
          redirect("/")
        else
          flash.now[:notice] = user.errors[:validation][0]
          render "login"
        end        
      end

    end

    get "/user/logout" do
      session.delete(:user)
      redirect("/user/login")
    end

    get "/user/register" do
      render "register"
    end

    post "/user/register" do

      rules = {
        :first_name => {:type => 'string', :required => true},
        :last_name => {:type => 'string', :required => true},
        :email => {:type => 'email', :required => true},
        :password => {:type => 'string', :required => true},
      }
      validator = Validator.new(params, rules)
      if !validator.valid?
        flash.now[:notice] = validator.errors[0][:error]
        render "register"
      else

        user = User.register_with_email(params)
        if user.errors.empty?
          session[:user] = user
          redirect("/user/wizard/1")
        else
          flash.now[:notice] = user.errors[:validation][0]
          render "register"
        end

      end

    end


    ### put your routes here ###
    get '/' do
      @posts = Post.order(:id).paginate(@page, @per_page).reverse
      render "index"
    end

    ### view page ###
    #get '/:title/:id' do
    #  @post = Post[params[:id]]
    #  render "post"
    #end

    get '/about' do
      render "about"
    end

    get '/user/wizard/:id' do
      @user = session[:user]
      zxcv = "profile_wizard_" + params[:id]
      render zxcv
    end

    post '/user/identity' do
      if params[:identity_id] == ""
        identity = Identity.new(params)
        identity.save
        redirect "/user/account"
      else
        identity = Identity.where(:id => params[:identity_id]).update(:username => params[:username], :gender => params[:gender], :birthday => params[:birthday])
        redirect "/user/account"
      end
    end

    post '/user/profile' do
      if params[:profile_id] == ""
        profile = Profile.new(params)
        profile.save
        redirect "/user/account"
      else
        profile = Profile.where(:id => params[:profile_id]).update(:summary => params[:summary])
        redirect "/user/account"
      end
    end

    post '/user/pictures' do
      if params[:picture]
        filename = params[:picture][:filename]
        tempfile = params[:picture][:tempfile]
        target = "/images/#{filename}"
        local_dest = Dir.pwd + "/public" + target

        FileUtils.mv(tempfile.path, local_dest)
        temp_pic = Picture.where(:user_id => params[:user_id]).first
        if temp_pic == nil
          picture = Picture.new(:user_id => params[:user_id], :image_url => target, :main_pic => "true")
          picture.save
        else
          picture = Picture.new(:user_id => params[:user_id], :image_url => target, :main_pic => "false")
          picture.save
        end

      end
      redirect "/user/account"
    end

    post '/user/picture_delete' do
      pic = Picture.where(:id => params[:id]).first
      pic.delete
    end

    get '/user/profile' do
      @identity = Identity.first
      @profile = Profile.first
      @picture = Picture.all
      render "profile_list"
    end


    get '/user/profile/:user_id' do
      userID = params[:user_id]
      @user = User.where(:id => userID).first
      @picture = Picture.where(:user_id => userID).all
      render "user_profile"
    end

    get '/display_users' do
      if session[:user][:id].nil?
        render "please_login"
      else
        sex = User.where(:id => session[:user][:id]).first[:gender]
        if sex == "male"
          @users = User.where(:gender => "female").all
          @pictures = Picture.all

          render "display_users"
        else
          @users = User.where(:gender => "male").all
          @pictures = Picture.all

          render "display_users"
        end
      end


    end

    post '/user/change_picture' do
      make_main = Picture.where(:id => params[:id]).first
      user_id = make_main[:user_id]
      pic_to_change = Picture.where(:user_id => user_id, :main_pic => "true").first
      if pic_to_change
        make_main[:main_pic] = "true"
        pic_to_change[:main_pic] = "false"
        make_main.save
        pic_to_change.save
      else
        make_main[:main_pic] = "true"
        make_main.save
      end

    end

    get '/viewprofile/:id' do
      @user = User.where(:id => params[:id]).first
      @session = session
      @related_messages = Message.where(:user_id => session[:user][:id], :send_to_id => params[:id]).or(:user_id => params[:id], :send_to_id => session[:user][:id]).all
      @pictures = Picture.where(:user_id => params[:id]).all

      render "user_profile"
    end

    get '/user/user_message' do
      @mes_received = Message.where(:send_to_id => session[:user][:id]).reverse_order(:id).all
      @mes_sent = Message.where(:user_id => session[:user][:id]).reverse_order(:id).all
      @user = User.all
      render "messages"
    end

    get '/user/message_from/:user_id' do
      @related_messages = Message.where(:user_id => params[:user_id], :send_to_id => session[:user][:id]).or(:user_id => session[:user][:id], :send_to_id => params[:user_id]).order(:sent_date).all
      @sendto_id = params[:user_id]
      @session = session
      render "view_message"
    end

    get '/view/message/:id' do

    end

    post '/message_input' do
      p "****************************************"
      message = Message.new(:user_id => params[:user_id], :send_to_id => params[:send_to_id], :content => params[:content], :sent_date => params[:sent_date])
      message.save
      p "****************************************"
    end

    post '/user/profile/save' do
      userdata = User.new(params)
      p "****************************************"
      p userdata

    end

    get '/temp_input' do
      @messages = Message.all
      render "temp_input"
    end

    post '/temp_input' do
      message = Message.new(:user_id => params[:user_id], :send_to_id => params[:send_to_id], :content => params[:content])
      message.save
      redirect '/temp_input'
    end


  end


end
