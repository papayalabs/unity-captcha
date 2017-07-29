# Unity Captcha

Unity Captcha is a gem that use two levels of Captcha. First level is about Left Hemisphere: Logic and Math. Second level is about Right Hemisphere: Intuition and Drawing. This two levels functioning in complete harmony creates unity and this is the base design of this Captcha.

The Left Hemisphere Level use a simple question of addition and multiplication. This works in the server side.

The Right Hemisphere Level use MotionCAPTCHA (https://github.com/wjcrowcroft/MotionCAPTCHA), that is a jQuery CAPTCHA plugin that requires users to sketch the shape they see in the canvas in order to submit a form. This works in the client side.

Dra. Jill Bolte Taylor got a research opportunity to study from inside of her brain how Left and Right Hemisphere works. I recommend to watch her in this video: https://www.ted.com/talks/jill_bolte_taylor_s_powerful_stroke_of_insight#t-1102370


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'unity-captcha'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install unity-captcha

## Usage

For the First level -  Left Hemisphere: Logic and Math ( Server Side ) we use some code in the controller and the view.

1. In your controller, for example if you have a method inside the controller called 'send_invite':

```ruby
class InviteController < ApplicationController
  def new
    @captcha = Unity::Captcha::Captcha.new
  end
  def send_invite
    @captcha = Unity::Captcha::Captcha.decrypt(params[:captcha_secret])
    email = params[:friend_email]
    unless @captcha.correct?(params[:captcha])
      @captcha = Unity::Captcha::Captcha.new
      redirect_to invite_url, :alert => "Please make sure you entered correct value for captcha."
    else  
      InviteMailer.invite_email(current_user, email).deliver_now
      flash[:notice] = "Thank you for inviting your friend! Please feel free to invite more!"
      redirect_to invite_url
    end  
  end
end
```

2. Ask the question in the form, example:

```erb
  <%= form_tag(send_invite_path, :method => :post) do %>
    <%= label_tag :friend_email, "Email" %>
	<%= text_field_tag :friend_email, nil, :size =>50, :class => "placeholder" %>
	<%= label_tag :question, "Question: "+@captcha.question %>
	<%= text_field_tag :captcha %>
	<%= hidden_field_tag :captcha_secret, @captcha.encrypt  %>
	
	<%= submit_tag "Send Invitation" %>
  <% end %>
```

For the Second level -  Right Hemisphere: Intuition and Drawing ( Cliend Side ) we just need to add some code in the form and make sure to add the plugin scripts: (MotionCAPTCHA is supported down to jQuery 1.4)

1. Adding plugin scripts ( usually added in application.html.erb ):

```erb
    <%= javascript_include_tag "https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"%>
    <%= stylesheet_link_tag "jquery.motionCaptcha.1.0" %>
    <%= javascript_include_tag "jquery.motionCaptcha.1.0" %>
    <%= javascript_include_tag "jquery.placeholder.1.1.1.min" %>	
```

2. Replace the submit_tag with the CAPTCHA canvas and a hidden_field_tag, like the following code ( remember to add :id => "mc-form" in form):

```erb
  <%= form_tag(send_invite_path, :method => :post, :id => "mc-form") do %>
    <%= label_tag :friend_email, "Email" %>
	<%= text_field_tag :friend_email, nil, :size =>50, :class => "placeholder" %
	<%= label_tag :question, "Question: "+@captcha.question %>
	<%= text_field_tag :captcha %>
	<%= hidden_field_tag :captcha_secret, @captcha.encrypt  %>
	
	<p>CAPTCHA: Please draw the shape in the box to submit the form: (<a onclick="window.location.reload()" href="#" title="Click for a new shape">new shape</a>)</p>
	<canvas id="mc-canvas"></canvas>
	<%= hidden_field_tag 'mc-action', send_invite_path.to_s %>
  <% end %>
```

You can also use simple_form:

```erb
  <%= simple_form_for send_invite_path,  :html => {:class => 'form-horizontal',:id => "mc-form" } do |f| %>
    <%= f.input :friend_email, label: 'Email',:class => "placeholder", :required => true %>		
	<%= f.input :captcha, label: @captcha.question, :required => true %>
	<%= f.input :captcha_secret, :as => :hidden, :input_html => { :value => @captcha.encrypt } %>
	
	<p>CAPTCHA: Please draw the shape in the box to submit the form: (<a onclick="window.location.reload()" href="#" title="Click for a new shape">new shape</a>)</p>
    <canvas id="mc-canvas"></canvas>
    <%= f.input :mc_action, :as => :hidden, :input_html => { :value => send_invite_path.to_s }	%>
  <% end %>
```

3. Initialize the javascrit component in the same form:

```erb
<script type="text/javaScript">
  jQuery(document).ready(function($) {
    $('#mc-form').motionCaptcha({
	  shapes: ['triangle', 'x', 'rectangle', 'circle', 'check', 'zigzag', 'arrow', 'delete', 'pigtail', 'star']
	});
	$("input.placeholder").placeholder();			
  });
</script>
```

4. Other options are available to initialize the canvas javascript component:

```erb
<script type="text/javaScript">
  jQuery(document).ready(function($) {
        $('#mc-form').motioncaptcha({
            // Basics:
            action: '#mc-action',        // the ID of the input containing the form action
            divId: '#mc',                // if you use an ID other than '#mc' for the placeholder, pass it in here
            cssClass: '.mc-active',      // this CSS class is applied to the 'mc' div when the plugin is active
            canvasId: '#mc-canvas',      // the ID of the MotionCAPTCHA canvas element
            
            // An array of shape names that you want MotionCAPTCHA to use:
            shapes: ['triangle', 'x', 'rectangle', 'circle', 'check', 'caret', 'zigzag', 'arrow', 'leftbracket', 'rightbracket', 'v', 'delete', 'star', 'pigtail'],
            
            // These messages are displayed inside the canvas after a user finishes drawing:
            errorMsg: 'Please try again.',
            successMsg: 'Captcha passed!',
            
            // This message is displayed if the user's browser doesn't support canvas:
            noCanvasMsg: "Your browser doesn't support <canvas> - try Chrome, FF4, Safari or IE9."
            
            // This could be any HTML string (eg. '<label>Draw this shit yo:</label>'):
            label: '<p>Please draw the shape in the box to submit the form:</p>'
        });
  });	
</script>
```

## Sites that use this gem

* [Artavita.com](http://artavita.com/) - invitation form (http://www.artavita.com/invite/new) and contact form in exhibit page (http://www.artavita.com/exhibits)

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/papayalabs/unity-captcha. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

