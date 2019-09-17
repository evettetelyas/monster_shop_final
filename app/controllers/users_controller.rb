class UsersController <ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @address = @user.addresses.new(address_params)
    @address.update(nickname: "home")
    if @user.save && @address.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome, #{@user.name}!"
      redirect_to "/profile"
    else
      flash[:error] = (@user.errors.full_messages + @address.errors.full_messages).uniq.to_sentence
      render :new
    end
  end

  def edit
    @user = User.find_by(id: session[:user_id])
    @address = @user.addresses.first
  end

  def show
    unless session[:user_id]
      render file: "/public/404"
    else
      if !params[:id].nil? && current_admin?
        @user = User.find(params[:id])
        @admin = User.find(session[:user_id])
        @address = @user.addresses.first
      else
        @user = User.find(session[:user_id])
        @address = @user.addresses.first
      end
    end
  end

  def update
    @user = User.find(session[:user_id])
    @address = @user.addresses.first
    if @user.update(profile_params) && @address.update(update_address_params)
      flash[:success] = 'Profile updated'
      redirect_to '/profile'
    elsif !@user.update(profile_params) && @address.update(update_address_params)
      flash[:error] = @user.errors.full_messages.uniq.to_sentence
      redirect_to '/profile/edit'
    elsif @user.update(profile_params) && !@address.update(update_address_params)
      flash[:error] = @address.errors.full_messages.uniq.to_sentence
      redirect_to '/profile/edit'
    else
      flash[:error] = (@address.errors.full_messages + @user.errors.full_messages).uniq.to_sentence
      redirect_to '/profile/edit'
    end
  end

  def edit_password
  end

  def update_password
    user = User.find(session[:user_id])
    if user.authenticate(old_password)
      if new_passwords_match?
        user.password = new_password
        user.save
        flash[:success] = 'You got a fresh new password, dawg!'
        redirect_to '/profile'
      else
        flash[:error] = "Your new password didn't match the confirmation"
        redirect_to '/profile/edit_password'
      end
    else
      flash[:error] = "Your old password didn't match the one on record"
      redirect_to '/profile/edit_password'
    end

  end

  private

  def update_password_params
    params.require(:update_password).permit(:old_password, :new_password, :new_password_confirmation)
  end

  def old_password
    update_password_params[:old_password]
  end

  def new_password
    update_password_params[:new_password]
  end

  def new_passwords_match?
    update_password_params[:new_password] == update_password_params[:new_password_confirmation]
  end

  def user_params
    params.permit(:name,:email,:password,:password_confirmation)
  end

  def address_params
    params.permit(:name,:address,:city,:state,:zip,:nickname)
  end

  def profile_params
    params.permit(:name,:email)
  end

  def update_address_params
    params.permit(:name,:address,:city,:state,:zip)
  end
end
