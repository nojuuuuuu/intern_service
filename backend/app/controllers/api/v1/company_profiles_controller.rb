module Api
  module V1
    class CompanyProfilesController < BaseController
      before_action :authenticate_user!
      before_action :set_company_profile, only: [:show, :update]
      before_action :authorize_ownership!, only: [:update]
      
      # GET /api/v1/company_profiles
      def index
        @company_profiles = CompanyProfile.all
        render_success(@company_profiles)
      end
      
      # GET /api/v1/company_profiles/:id
      def show
        render_success(@company_profile)
      end
      
      # GET /api/v1/company_profiles/me
      def me
        if current_user.company?
          render_success(current_user.company_profile)
        else
          render_unauthorized
        end
      end
      
      # PATCH/PUT /api/v1/company_profiles/:id
      def update
        if @company_profile.update(company_profile_params)
          render_success(@company_profile)
        else
          render_error('プロフィールの更新に失敗しました', :unprocessable_entity, @company_profile.errors.full_messages)
        end
      end
      
      private
      
      def set_company_profile
        @company_profile = CompanyProfile.find_by(id: params[:id])
        render_not_found('企業プロフィール') unless @company_profile
      end
      
      def company_profile_params
        params.require(:company_profile).permit(
          :company_name, :description, :industry, 
          :location, :website, :company_size, :founding_year
        )
      end
      
      def authorize_ownership!
        render_unauthorized unless current_user.company? && current_user.company_profile.id == @company_profile.id
      end
    end
  end
end 