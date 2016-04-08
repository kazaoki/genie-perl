# encoding: utf-8

require 'capybara/rspec'
require 'capybara/poltergeist'
require 'capybara/user_agent'
require 'gnawrnip'
require 'addressable/uri'
require 'selenium-webdriver'

base_wait_time = 60

# --------------------------------------------------------------------
# 基本設定
# --------------------------------------------------------------------
Dir.glob('/opt/spec/steps/*steps.rb') { |f| load f, true }
Capybara.default_driver = :poltergeist
# Capybara.default_driver = :remote_browser
Capybara.default_max_wait_time = base_wait_time
RSpec.configure do |config|
  Encoding.default_external = Encoding::UTF_8
  config.include Capybara::UserAgent::DSL
  # config.fuubar_progress_bar_options = { :format => 'My Fuubar! <%B> %p%% %a' }
end

# --------------------------------------------------------------------
# Poltergeist設定
# --------------------------------------------------------------------
Capybara.register_driver :poltergeist do |app|
  ghost_busters = Capybara::Poltergeist::Driver.new(app, {
      js_errors:         ENV['SPEC_JS_ERRORS']=="1",
      window_size:       [ENV['SPEC_CAPTURE_WIDTH'], 1024],
      timeout:           base_wait_time,
      phantomjs_options: ["--config=/opt/spec/confs/config.json"]
    })
  if ENV['SPEC_USER_AGENT'] != "" then
    ghost_busters.headers = { 'User-Agent' => ENV['SPEC_USER_AGENT'] }
  end
  ghost_busters
end

# --------------------------------------------------------------------
# リモートブラウザ設定
# --------------------------------------------------------------------
Capybara.register_driver :remote_browser do |app|
  Capybara::Selenium::Driver.new(app, {
    desired_capabilities: {
      'platform' => 'LINUX',   'browserName' => 'firefox',           'version' => '', 'javascriptEnabled' => true
      # 'platform' => 'LINUX',   'browserName' => 'chrome',            'version' => '', 'javascriptEnabled' => true
      # 'platform' => 'WINDOWS', 'browserName' => 'firefox',           'version' => '', 'javascriptEnabled' => true
      # 'platform' => 'WINDOWS', 'browserName' => 'chrome',            'version' => '', 'javascriptEnabled' => true # x
      # 'platform' => 'WINDOWS', 'browserName' => 'internet explorer', 'version' => '', 'javascriptEnabled' => true # x
    },
    browser: :remote,
    url: 'http://192.168.0.11:4444/wd/hub'
  });
end

# --------------------------------------------------------------------
# レポート出力設定
# --------------------------------------------------------------------
if ENV['SPEC_HTML_REPORT'] == "1" then
  TurnipFormatter.configure do |config|
    config.title = ENV['SPEC_CONTAINER'] + ' report'
    config.add_stylesheet '/opt/spec/confs/report-add.css'
  end
  Gnawrnip.configure do |config|
    config.make_animation = true
    config.max_frame_size = 1024 # pixel
  end
end

# --------------------------------------------------------------------
# 「\n」を改行コードに変換します。「\\n」とすれば文字としての「\n」になります。
# --------------------------------------------------------------------
def multi (string)
  string.to_s.gsub(/(?<!\\)\\n/, "\n").gsub('\\\\n', '\n')
end
