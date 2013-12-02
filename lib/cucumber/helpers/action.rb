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
    expect(Capybara.html).not_to include(Cucumber::Helper.error_message) if Cucumber::Helper.error_message

    if Capybara.current_url.start_with? 'https'
      incorrect_urls = []
      [
        ['img', 'src']
        ['script', 'src']
        ['link', 'href'],
        ['form', 'action'],
        ['video', 'data-stream'],
        ['source', 'src'],
        ['audio', 'src'],
        ['iframe', 'src'],
        ['object', 'src'],
      ].each do |tag_attr|
        Capybara.all(tag_attr[0], visible: false).each do |tag|
          attribute = tag[tag_attr[1]]
          if attribute
            incorrect_urls << attribute if attribute.downcase.start_with?('http://')
          end
        end
      end
      expect(incorrect_urls).to be_empty
    end
  end
end
World(Action)
