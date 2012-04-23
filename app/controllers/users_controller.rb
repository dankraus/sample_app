class UsersController < ApplicationController
	before_filter :signed_in_user, only: [:index, :edit, :update]
	before_filter :correct_user,   only: [:edit, :update]
	before_filter :admin_user, only: [:destroy]

	def index
		@users = User.paginate(page: params[:page])
	end

	def show
		@user = User.find(params[:id])
	end

	def new
		if !signed_in?
			@user = User.new
		else
			redirect_to root_path
		end
	end

	def create
		if !signed_in?
			@user = User.new(params[:user])
			if @user.save
				sign_in @user
				flash[:success] = "Welcome to the Sample App!"
				redirect_to @user
			else
				render 'new'
			end
		else
			redirect_to root_path
		end
	end

	def edit
	end

	def update
		if @user.update_attributes(params[:user])
			flash[:success] = "Profile updated"
			sign_in @user
			redirect_to @user
		else
			render 'edit'
		end
	end

	def destroy
		#only admins can delete, and they can't delete themselves
		user = User.find(params[:id])
		if current_user != user 
			user.destroy
			flash[:success] = "User destroyed"
		else
			flash[:success] = "Admins cannot delete themselves"
		end
		redirect_to users_path
	end

	private
		def signed_in_user
			unless signed_in?
				store_location
				redirect_to signin_path, notice: "Please sign in." unless signed_in?
			end
		end

		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_path) unless current_user?(@user)
		end

		def admin_user
			redirect_to(root_path) unless current_user.admin?
		end
end
