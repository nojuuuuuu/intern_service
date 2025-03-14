module Api
  module V1
    class UsersController < BaseController
      before_action :authenticate_user!, except: [:create, :login]
      before_action :set_user, only: [:show, :update, :destroy]
      
      # GET /api/v1/users
      def index
        @users = User.all
        render_success(@users)
      end
      
      # GET /api/v1/users/:id
      def show
        render_success(@user)
      end
      
      # POST /api/v1/users
      def create
        @user = User.new(user_params)
        
        if @user.save
          # ユーザーのロールに基づいてプロフィールを作成
          if @user.candidate?
            @user.create_candidate_profile
          elsif @user.company?
            @user.create_company_profile(company_name: "未設定")
          end
          
          render_success(@user, :created)
        else
          render_error('ユーザー登録に失敗しました', :unprocessable_entity, @user.errors.full_messages)
        end
      end
      
      # PATCH/PUT /api/v1/users/:id
      def update
        if @user.update(user_params)
          render_success(@user)
        else
          render_error('ユーザー情報の更新に失敗しました', :unprocessable_entity, @user.errors.full_messages)
        end
      end
      
      # DELETE /api/v1/users/:id
      def destroy
        @user.destroy
        render_success(message: 'ユーザーを削除しました')
      end
      
      # POST /api/v1/login
      def login
        @user = User.find_by(email: params[:email])
        
        if @user&.authenticate(params[:password])
          # 認証成功時のレスポンス（トークン生成は後で実装）
          render_success({
            user: @user,
            token: 'dummy_token' # 後でJWT実装時に変更
          })
        else
          render_unauthorized
        end
      end
      
      # GET /api/v1/me
      def me
        render_success(current_user)
      end
      
      private
      
      def set_user
        @user = User.find_by(id: params[:id])
        render_not_found('ユーザー') unless @user
      end
      
      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation, :role)
      end
    end
  end
end 