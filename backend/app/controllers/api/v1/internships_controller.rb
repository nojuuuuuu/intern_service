module Api
  module V1
    class InternshipsController < BaseController
      before_action :authenticate_user!, except: [:index, :show]
      before_action :set_internship, only: [:show, :update, :destroy]
      before_action :authorize_company!, only: [:create, :update, :destroy]
      
      # GET /api/v1/internships
      def index
        @internships = Internship.all
        
        # フィルター処理
        @internships = @internships.where(status: params[:status]) if params[:status].present?
        @internships = @internships.with_skills(params[:skills]) if params[:skills].present?
        @internships = @internships.active if params[:active] == 'true'
        
        # 企業IDによるフィルター
        @internships = @internships.where(company_profile_id: params[:company_profile_id]) if params[:company_profile_id].present?
        
        render_success(@internships)
      end
      
      # GET /api/v1/internships/:id
      def show
        render_success(@internship)
      end
      
      # POST /api/v1/internships
      def create
        @internship = current_company_profile.internships.new(internship_params)
        
        if @internship.save
          render_success(@internship, :created)
        else
          render_error('インターンシップの作成に失敗しました', :unprocessable_entity, @internship.errors.full_messages)
        end
      end
      
      # PATCH/PUT /api/v1/internships/:id
      def update
        authorize_ownership!(@internship.company_profile)
        
        if @internship.update(internship_params)
          render_success(@internship)
        else
          render_error('インターンシップの更新に失敗しました', :unprocessable_entity, @internship.errors.full_messages)
        end
      end
      
      # DELETE /api/v1/internships/:id
      def destroy
        authorize_ownership!(@internship.company_profile)
        
        @internship.destroy
        render_success(message: 'インターンシップを削除しました')
      end
      
      private
      
      def set_internship
        @internship = Internship.find_by(id: params[:id])
        render_not_found('インターンシップ') unless @internship
      end
      
      def internship_params
        params.require(:internship).permit(
          :title, :description, :location, :remote_available, 
          :duration, :start_date, :end_date, :application_deadline, 
          :status, :required_skills, :responsibilities, 
          :qualifications, :benefits, :positions_available
        )
      end
      
      def current_company_profile
        current_user.company_profile
      end
      
      def authorize_company!
        render_unauthorized unless current_user&.company?
      end
      
      def authorize_ownership!(company_profile)
        render_unauthorized unless current_user&.company_profile&.id == company_profile.id
      end
    end
  end
end 