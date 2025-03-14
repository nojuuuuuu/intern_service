module Api
  module V1
    class ApplicationsController < BaseController
      before_action :authenticate_user!
      before_action :set_application, only: [:show, :update, :review, :accept, :reject]
      before_action :authorize_candidate!, only: [:create]
      before_action :authorize_company!, only: [:review, :accept, :reject]
      
      # GET /api/v1/applications
      def index
        if current_user.company?
          # 企業ユーザーの場合、自社のインターンシップへの応募
          @applications = Application.for_company(current_user.company_profile.id)
        elsif current_user.candidate?
          # 候補者ユーザーの場合、自分の応募
          @applications = current_user.candidate_profile.applications
        else
          return render_unauthorized
        end
        
        # ステータスでフィルタリング
        @applications = @applications.where(status: params[:status]) if params[:status].present?
        
        # インターンシップIDでフィルタリング
        @applications = @applications.where(internship_id: params[:internship_id]) if params[:internship_id].present?
        
        render_success(@applications)
      end
      
      # GET /api/v1/applications/:id
      def show
        authorize_access!
        render_success(@application)
      end
      
      # POST /api/v1/applications
      def create
        @application = current_user.candidate_profile.applications.new(application_params)
        
        if @application.save
          render_success(@application, :created)
        else
          render_error('応募に失敗しました', :unprocessable_entity, @application.errors.full_messages)
        end
      end
      
      # PATCH/PUT /api/v1/applications/:id/review
      def review
        authorize_company_ownership!
        
        if @application.start_review
          render_success(@application)
        else
          render_error('レビュー状態への更新に失敗しました', :unprocessable_entity, @application.errors.full_messages)
        end
      end
      
      # PATCH/PUT /api/v1/applications/:id/accept
      def accept
        authorize_company_ownership!
        
        if @application.accept
          render_success(@application)
        else
          render_error('応募の承認に失敗しました', :unprocessable_entity, @application.errors.full_messages)
        end
      end
      
      # PATCH/PUT /api/v1/applications/:id/reject
      def reject
        authorize_company_ownership!
        
        if @application.reject(params[:rejection_reason])
          render_success(@application)
        else
          render_error('応募の拒否に失敗しました', :unprocessable_entity, @application.errors.full_messages)
        end
      end
      
      private
      
      def set_application
        @application = Application.find_by(id: params[:id])
        render_not_found('応募') unless @application
      end
      
      def application_params
        params.require(:application).permit(:internship_id, :cover_letter, :additional_information)
      end
      
      def authorize_candidate!
        render_unauthorized unless current_user&.candidate?
      end
      
      def authorize_company!
        render_unauthorized unless current_user&.company?
      end
      
      def authorize_access!
        # 企業ユーザーの場合、自社のインターンシップへの応募か確認
        if current_user.company?
          render_unauthorized unless @application.internship.company_profile_id == current_user.company_profile.id
        # 候補者ユーザーの場合、自分の応募か確認
        elsif current_user.candidate?
          render_unauthorized unless @application.candidate_profile_id == current_user.candidate_profile.id
        else
          render_unauthorized
        end
      end
      
      def authorize_company_ownership!
        render_unauthorized unless @application.internship.company_profile_id == current_user.company_profile.id
      end
    end
  end
end 