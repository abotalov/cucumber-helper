module Action

  def click_link(locator)
    Capybara.click_link(locator)
    assert_html
  end

  def click_button(locator)
    Capybara.click_button(locator)
    assert_html
  end

  def execute_script(script)
    Capybara.page.execute_script(script)
    assert_html
  end

  def visit(page)
    Capybara.visit(page)
    assert_html
  end

  private
  def assert_html
    Capybara.html.should_not include Cucumber::Helper.error_message if Cucumber::Helper.error_message
  end
end
World(Action)

