module Unity
  module Captcha
    class Engine < ::Rails::Engine
      initializer 'static_assets.load_static_assets' do |app|
        app.middleware.use ::ActionDispatch::Static, "#{root}/vendor"
      end
      
      initializer 'unity_captcha.action_view.helpers' do
        ActiveSupport.on_load :action_view do
          require 'unity/captcha/view_helpers'
          include Unity::Captcha::ViewHelpers
        end
      end
    end  
  end
end

