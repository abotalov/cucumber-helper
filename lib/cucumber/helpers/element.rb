module Capybara
  module Node
    class Element < Base
      include RSpec::Matchers

      def click
        wait_until { base.click }
        Capybara.html.should_not include Cucumber::Helper.error_message if Cucumber::Helper.error_message
      end
    end
  end
end
