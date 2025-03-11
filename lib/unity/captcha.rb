require "unity/captcha/version"
require "unity/captcha/engine"
require "base64"
require "yaml"

module Unity
  module Captcha
    class Captcha 
      attr_accessor :operand1, :operand2, :operator

      def initialize
        @operand1 = (1..10).to_a.sample
        @operand2 = (1..10).to_a.sample
        @operator = [:+, :*].sample  
      end

      def initialize_from(secret)
        yml = YAML.load(Base64.decode64(secret))
        @operand1, @operand2, @operator = yml[:operand1], yml[:operand2], yml[:operator]
      end

      def correct?(value)
        result == value.to_i
      end

      def encrypt
      	Base64.encode64 to_yaml
      end

      def self.decrypt(secret)
        result = new
        result.initialize_from secret
        result
      end

      def to_yaml
        YAML::dump({
          :operand1 => @operand1,
          :operand2 => @operand2,
          :operator => @operator
        })
      end

      def question
        "What is #{@operand1} #{@operator.to_s} #{@operand2} = ?"
      end

      private

      def result
        @operand1.send @operator, @operand2
      end
    end
  end
end
