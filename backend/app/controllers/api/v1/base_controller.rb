module Api
  module V1
    class BaseController < ApplicationController
      # CSRFトークン検証をスキップ（APIはトークンベースの認証を使用するため）
      skip_before_action :verify_authenticity_token, if: -> { request.format.json? }
      
      # レスポンス用のヘルパーメソッド
      def render_success(data = {}, status = :ok)
        render json: { success: true, data: data }, status: status
      end
      
      def render_error(message = 'エラーが発生しました', status = :unprocessable_entity, errors = [])
        render json: { 
          success: false, 
          message: message,
          errors: errors
        }, status: status
      end
      
      # 認証エラー発生時の処理
      def render_unauthorized
        render_error('認証に失敗しました', :unauthorized)
      end
      
      # リソースが見つからない場合の処理
      def render_not_found(resource = 'リソース')
        render_error("#{resource}が見つかりませんでした", :not_found)
      end
      
      private
      
      # 現在のユーザーを取得するメソッド（後で認証機能と連携）
      def current_user
        # 実際の認証実装時にはトークンからユーザーを取得
        @current_user ||= nil
      end
      
      # ユーザーが認証済みかどうかを確認
      def authenticate_user!
        render_unauthorized unless current_user
      end
      
      # 認可チェック（権限確認）
      def authorize_user!(resource)
        # リソースに対する操作権限をチェック（所有者か確認など）
        # 実装例: render_unauthorized unless resource.user_id == current_user.id
      end
    end
  end
end 