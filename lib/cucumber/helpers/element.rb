module Capybara
  module Node
    class Element < Base
      include RSpec::Matchers

      alias click_orig click
      def click
        click_orig
        Capybara.html.should_not include Cucumber::Helper.error_message if Cucumber::Helper.error_message
      end
    end
  end
end
