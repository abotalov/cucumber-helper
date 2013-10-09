require "cucumber-helper/version"
require "cucumber"
require 'cucumber/cli/options'
require 'cucumber/helpers/action'
require 'cucumber/helpers/element'

Cucumber::Cli::Options::BUILTIN_FORMATS['cuckebar'] = [
  "Cucumber::Formatter::CuckeBar",
  "The instafailing Cucumber progress bar formatter"
]

module Cucumber
  module Helper
    class << self
      attr_accessor :error_message

      def configure
	yield self
      end
    
    end

  end
end

Cucumber::Helper.configure do |config|
  config.error_message = nil
end
