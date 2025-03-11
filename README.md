# Unity Captcha

Unity Captcha is a gem that uses two levels of Captcha:

1. **Left Hemisphere Level**: Logic and Math - A simple math question (addition or multiplication) handled on the server side.
2. **Right Hemisphere Level**: Intuition and Drawing - Uses MotionCAPTCHA, requiring users to draw a shape they see in a canvas (client-side verification).

These two levels, functioning in harmony, create a secure and engaging captcha experience.

Inspired by Dr. Jill Bolte Taylor's research on brain hemispheres. Learn more: [TED Talk](https://www.ted.com/talks/jill_bolte_taylor_s_powerful_stroke_of_insight)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'unity-captcha'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install unity-captcha
```

## Usage

### Quick Start with `captcha_for` Helper

The gem now provides a simple `captcha_for` helper that automatically adds all required assets and markup:

```erb
<%= form_tag(send_invite_path, method: :post, id: "mc-form") do %>
  <%= label_tag :friend_email, "Email" %>
  <%= text_field_tag :friend_email %>
  
  <%= captcha_for %>
  
  <%= submit_tag "Send Invitation" %>
<% end %>
```

In your controller:

```ruby
class InviteController < ApplicationController
  def send_invite
    @captcha = Unity::Captcha::Captcha.decrypt(params[:captcha_secret])
    
    unless @captcha.correct?(params[:captcha])
      redirect_to invite_url, alert: "Please enter the correct captcha value."
    else
      # Process your form...
      redirect_to success_url, notice: "Form submitted successfully!"
    end
  end
end
```

### Form Builder Integration

Works with form builders like simple_form:

```erb
<%= simple_form_for(@invite, html: {id: 'mc-form'}) do |f| %>
  <%= f.input :email %>
  
  <%= captcha_for(f) %>
  
  <%= f.button :submit %>
<% end %>
```

### Customization Options

```erb
<%= captcha_for(f, {
  # Canvas appearance
  label: 'Draw the shape to verify:',
  canvas_id: 'my-custom-canvas',
  form_id: 'my-form-id',
  html_options: { class: 'custom-canvas', style: 'border: 3px solid #333' },
  
  # Shape options
  shapes: ['triangle', 'x', 'rectangle', 'circle', 'check'],
  
  # Messages
  error_msg: 'Not quite right, try again.',
  success_msg: 'Perfect! Form submitted.',
  
  # Asset options
  skip_jquery: true, # Skip jQuery if you already include it
  
  # Form submission
  action_path: custom_submit_path
}) %>
```

### Available Shapes

The following shapes are available (you can use any subset):

```
'triangle', 'x', 'rectangle', 'circle', 'check', 'caret', 'zigzag', 
'arrow', 'leftbracket', 'rightbracket', 'v', 'delete', 'star', 'pigtail'
```

## How It Works

Unity Captcha combines:

1. **Math Challenge**: Server-side validation of a simple math problem
2. **Drawing Challenge**: Client-side validation of a drawn shape using pattern recognition

Both must be correct for the form to submit, providing dual-layer security.

## Advanced Usage

For more control or custom implementations, you can use the traditional approach:

```ruby
# Controller
def new
  @captcha = Unity::Captcha::Captcha.new
end
```

```erb
<%# View %>
<%= form_tag(submit_path, method: :post, id: "mc-form") do %>
  <%# Math captcha %>
  <%= label_tag :captcha, @captcha.question %>
  <%= text_field_tag :captcha %>
  <%= hidden_field_tag :captcha_secret, @captcha.encrypt %>
  
  <%# Drawing captcha %>
  <p>Please draw the shape: <a onclick="window.location.reload()" href="#">(new shape)</a></p>
  <canvas id="mc-canvas"></canvas>
  <%= hidden_field_tag 'mc-action', submit_path %>
  
  <%= submit_tag "Submit" %>
<% end %>

<%# Initialize JavaScript %>
<script>
  jQuery(document).ready(function($) {
    $('#mc-form').motionCaptcha({
      shapes: ['triangle', 'x', 'rectangle', 'circle', 'check']
    });
  });
</script>
```

Make sure to include the required assets:

```erb
<%= javascript_include_tag "jquery.min" %>
<%= stylesheet_link_tag "jquery.motionCaptcha.1.0" %>
<%= javascript_include_tag "jquery.motionCaptcha.1.0", "jquery.placeholder.1.1.1.min" %>
```

## Sites Using Unity Captcha

* [Artavita.com](http://artavita.com/) - Invitation form and exhibit contact forms

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/papayalabs/unity-captcha. Contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

