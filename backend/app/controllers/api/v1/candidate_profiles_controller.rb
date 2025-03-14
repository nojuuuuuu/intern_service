module Api
  module V1
    class CandidateProfilesController < BaseController
      before_action :authenticate_user!
      before_action :set_candidate_profile, only: [:show, :update]
      before_action :authorize_ownership!, only: [:update]
      
      # GET /api/v1/candidate_profiles
      def index
        # 企業ユーザーのみがすべての候補者プロフィールを閲覧可能
        if current_user.company?
          @candidate_profiles = CandidateProfile.all
          render_success(@candidate_profiles)
        else
          render_unauthorized
        end
      end
      
      # GET /api/v1/candidate_profiles/:id
      def show
        render_success(@candidate_profile)
      end
      
      # GET /api/v1/candidate_profiles/me
      def me
        if current_user.candidate?
          render_success(current_user.candidate_profile)
        else
          render_unauthorized
        end
      end
      
      # PATCH/PUT /api/v1/candidate_profiles/:id
      def update
        if @candidate_profile.update(candidate_profile_params)
          render_success(@candidate_profile)
        else
          render_error('プロフィールの更新に失敗しました', :unprocessable_entity, @candidate_profile.errors.full_messages)
        end
      end
      
      private
      
      def set_candidate_profile
        @candidate_profile = CandidateProfile.find_by(id: params[:id])
        render_not_found('候補者プロフィール') unless @candidate_profile
      end
      
      def candidate_profile_params
        params.require(:candidate_profile).permit(
          :name, :bio, :university, :major, 
          :graduation_year, :skills, :interests
        )
      end
      
      def authorize_ownership!
        render_unauthorized unless current_user.candidate? && current_user.candidate_profile.id == @candidate_profile.id
      end
    end
  end
end 