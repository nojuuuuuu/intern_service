module Api
  module V1
    class ScoutsController < BaseController
      before_action :authenticate_user!
      before_action :set_scout, only: [:show, :update, :respond]
      before_action :authorize_company!, only: [:create]
      before_action :authorize_candidate!, only: [:respond]
      
      # GET /api/v1/scouts
      def index
        if current_user.company?
          # 企業ユーザーの場合、自分が送信したスカウト
          @scouts = current_user.company_profile.scouts
        elsif current_user.candidate?
          # 候補者ユーザーの場合、自分が受信したスカウト
          @scouts = current_user.candidate_profile.scouts
        else
          return render_unauthorized
        end
        
        # ステータスでフィルタリング
        @scouts = @scouts.where(status: params[:status]) if params[:status].present?
        
        render_success(@scouts)
      end
      
      # GET /api/v1/scouts/:id
      def show
        authorize_access!
        
        # 候補者がスカウトを閲覧した場合、既読にする
        if current_user.candidate? && current_user.candidate_profile.id == @scout.candidate_profile_id
          @scout.mark_as_read
        end
        
        render_success(@scout)
      end
      
      # POST /api/v1/scouts
      def create
        @scout = current_user.company_profile.scouts.new(scout_params)
        
        if @scout.save
          render_success(@scout, :created)
        else
          render_error('スカウトの送信に失敗しました', :unprocessable_entity, @scout.errors.full_messages)
        end
      end
      
      # POST /api/v1/scouts/:id/respond
      def respond
        authorize_candidate_ownership!
        
        accept = params[:accept] == 'true'
        
        if @scout.respond(accept)
          render_success(@scout)
        else
          render_error('スカウトへの回答に失敗しました', :unprocessable_entity, @scout.errors.full_messages)
        end
      end
      
      private
      
      def set_scout
        @scout = Scout.find_by(id: params[:id])
        render_not_found('スカウト') unless @scout
      end
      
      def scout_params
        params.require(:scout).permit(:candidate_profile_id, :internship_id, :title, :message)
      end
      
      def authorize_company!
        render_unauthorized unless current_user&.company?
      end
      
      def authorize_candidate!
        render_unauthorized unless current_user&.candidate?
      end
      
      def authorize_access!
        # 企業ユーザーの場合、自分が送信したスカウトか確認
        if current_user.company?
          render_unauthorized unless current_user.company_profile.id == @scout.company_profile_id
        # 候補者ユーザーの場合、自分が受信したスカウトか確認
        elsif current_user.candidate?
          render_unauthorized unless current_user.candidate_profile.id == @scout.candidate_profile_id
        else
          render_unauthorized
        end
      end
      
      def authorize_candidate_ownership!
        render_unauthorized unless current_user.candidate_profile.id == @scout.candidate_profile_id
      end
    end
  end
end 