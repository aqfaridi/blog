class RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_in_params, only: [:create]

  # POST /resource/sign_up
  def create
    params[:user][:roles] = ["viewer"]
    super
  end

  # def update_resource(resource, params)
  #   resource.update_without_password(params)
  # end

end
