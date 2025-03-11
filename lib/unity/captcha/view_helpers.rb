module Unity
  module Captcha
    module ViewHelpers
      # Helper method to generate a Unity Captcha field in forms
      # 
      # @param form [FormBuilder] The form object
      # @param options [Hash] Options for customizing the captcha
      # @option options [String] :label The label for the captcha field
      # @option options [Array<String>] :shapes List of shapes to use
      # @option options [String] :error_msg Error message to display
      # @option options [String] :success_msg Success message to display
      # @option options [String] :form_id ID for the form (defaults to "mc-form")
      # @option options [String] :canvas_id ID for the canvas (defaults to "mc-canvas")
      # @option options [Hash] :html_options Additional HTML options for the canvas
      #
      # @return [String] HTML markup for the captcha
      def captcha_for(form = nil, options = {})
        # Create the captcha object if not passed
        @captcha ||= Unity::Captcha::Captcha.new
        
        options = {
          label: 'Please draw the shape in the box to submit the form:',
          shapes: ['triangle', 'x', 'rectangle', 'circle', 'check', 'zigzag', 'arrow', 'delete', 'pigtail', 'star'],
          error_msg: 'Please try again.',
          success_msg: 'Captcha passed!',
          form_id: 'mc-form',
          canvas_id: 'mc-canvas',
          html_options: {}
        }.merge(options)
        
        # Include required assets
        output = javascript_include_tag("https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js") unless options[:skip_jquery]
        output = (output || '').html_safe
        output += javascript_include_tag("jquery.motionCaptcha.1.0", "jquery.placeholder.1.1.1.min")
        output += stylesheet_link_tag("jquery.motionCaptcha.1.0")
        
        # Generate the form ID - if we're in a form, use that form's ID or set it
        form_id = options[:form_id]
        if form.present?
          # If we're in a form_for/simple_form_for block
          form.object_name # make sure it's a form object
          
          # Math captcha question field
          output += form.label :captcha, @captcha.question
          output += form.text_field :captcha
          output += form.hidden_field :captcha_secret, value: @captcha.encrypt
          
          # Drawing captcha
          output += content_tag(:p, options[:label].html_safe + 
                     content_tag(:a, ' (new shape)', href: '#', 
                                onclick: "window.location.reload()", 
                                title: "Click for a new shape"))
          output += content_tag(:canvas, '', { id: options[:canvas_id] }.merge(options[:html_options]))
          
          # Hidden action field
          action_path = options[:action_path] || request.path
          output += form.hidden_field :mc_action, value: action_path
        else
          # If we're just rendering the captcha standalone
          output += label_tag :captcha, @captcha.question
          output += text_field_tag :captcha
          output += hidden_field_tag :captcha_secret, @captcha.encrypt
          
          # Drawing captcha
          output += content_tag(:p, options[:label].html_safe + 
                     content_tag(:a, ' (new shape)', href: '#', 
                                onclick: "window.location.reload()", 
                                title: "Click for a new shape"))
          output += content_tag(:canvas, '', { id: options[:canvas_id] }.merge(options[:html_options]))
          
          # Hidden action field
          action_path = options[:action_path] || request.path
          output += hidden_field_tag :mc_action, action_path
        end
        
        # Initialize the javascript
        shapes_json = options[:shapes].to_json
        script = <<-JAVASCRIPT
        <script type="text/javascript">
          jQuery(document).ready(function($) {
            $('##{form_id}').motionCaptcha({
              shapes: #{shapes_json},
              errorMsg: "#{options[:error_msg]}",
              successMsg: "#{options[:success_msg]}"
            });
            $("input.placeholder").placeholder();
          });
        </script>
        JAVASCRIPT
        
        output += script.html_safe
        output
      end
    end
  end
end