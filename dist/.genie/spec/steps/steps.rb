# encoding: utf-8
# language: ja


# --------------------------------------------------------------------
# 初期設定
# --------------------------------------------------------------------
dirname = 'cap-' + Time.now.strftime('%Y%m%d-%H%M%S')
autocap = ENV['GENIE_SPEC_AUTOCAP']
autocap_addname = '' # 自動キャプチャのファイル名に一時的に付加する名前（一度キャプチャされると空白に戻る）

# --------------------------------------------------------------------
# ページナビゲーション：アクション
# --------------------------------------------------------------------

step '基本URLを:urlにする' do |url|
  Capybara.app_host = url
end

step 'ページ:pathを表示する' do |path|
  visit (path)
  step 'cap' if autocap
end

step ':filenameにキャプチャする' do |filename|
  page.save_screenshot('/spec/captures/'+filename, :full => true)
end

# // 簡易キャプチャ（自動ファイル名付け）
step 'cap' do
  base = self.pretty_inspect.match(/\(\/spec\/features\/([^\(\)]+)\.feature\:(\d+)\)\>$/)
  line = caller.pretty_inspect.match(/\.feature\:(\d+)/)
  filepath = sprintf("/spec/captures/%s/%s/%05d-%05d"+autocap_addname+".png", dirname, base[1], base[2], line[1])
  page.save_screenshot(filepath, :full => true)
  autocap_addname = ''
end

step '戻る' do
  page.go_back();
  step 'cap' if autocap
end

step '進む' do
  page.go_forward();
  step 'cap' if autocap
end

step 'リロードする' do
  visit current_path
  step 'cap' if autocap
end

# --------------------------------------------------------------------
# ページナビゲーション：確認
# --------------------------------------------------------------------

step 'パスが:pathである' do |path|
  # uri = Addressable::URI.parse URI.unescape(current_url)
  uri = Addressable::URI.parse current_url
  # path = path.gsub(/\=([^\?\&\=]+)/){ |data| '='+CGI.escape($1) }
  if uri.query.to_s.empty? then
    expect("#{uri.path}").to eq(path)
  else
    expect("#{uri.path}?#{uri.query}").to eq(path)
  end
end

step 'パスがエスケープされていない:pathである' do |path|
  uri = Addressable::URI.parse current_url
  # path = path.gsub(/\=([^\?\&\=]+)/){ |data| '='+CGI.escape($1) }
  path = URI.escape path
  if uri.query.to_s.empty? then
    expect("#{uri.path}").to eq(path)
  else
    expect("#{uri.path}?#{uri.query}").to eq(path)
  end
end

step 'URLが:urlである' do |url|
  expect(current_url).to eq url
end

step 'HTTPステータスコードが:numである' do |num|
	expect(page).to have_http_status(num)
end

step 'HTTPステータスコードが:numではない' do |num|
	expect(page).not_to have_http_status(num)
end

step 'レスポンスヘッダ:typeが:valueである' do |type, value|
  expect(page.response_headers[type]).to eq(value)
end

step 'レスポンスヘッダ:typeが:valueではない' do |type, value|
  expect(page.response_headers[type]).not_to eq(value)
end

# --------------------------------------------------------------------
# ブラウザ操作
# --------------------------------------------------------------------

step ':sec秒待つ' do |sec|
  sleep sec.to_i
  step 'cap' if autocap
end

step '最後に開いたウィンドウに移動する' do
  page.driver.browser.switch_to_window(page.driver.browser.window_handles.last)
  page.driver.resize_window(ENV['GENIE_SPEC_DEFAULT_CAPTURE_WIDTH'], 500)
  step 'cap' if autocap
end

step 'ウィンドウを閉じる' do
  page.execute_script "window.close();"
  page.driver.browser.switch_to_window(page.driver.browser.window_handles.last)
end

step 'ウィンドウの幅を:widthにする' do |width|
  if width == 'default'
    width = ENV['GENIE_SPEC_DEFAULT_CAPTURE_WIDTH']
  end
  if ENV['GENIE_SPEC_BROWSER'] == "firefox" then
    Capybara.current_session.driver.browser.manage.window.resize_to(width, 500)
  else
    page.driver.resize_window(width, 500)
  end
end

step 'BASIC認証のユーザー名を:user、パスワードを:passにする' do |user, pass|
  page.driver.basic_authorize(user, pass)
end
step 'BASIC認証をクリアする' do
  headers = page.driver.headers
  headers.delete('Authorization')
  page.driver.headers = headers
end

step 'UAを:uaにする' do |ua|
  if ua == 'default'
    ua = ENV['GENIE_SPEC_DEFAULT_USER_AGENT']
  end

  if ENV['GENIE_SPEC_BROWSER'] == "firefox" then
    
    # Capybara.current_session.driver = Webdriver::UserAgent.driver(:agent => ua)
    # Capybara.current_session.driver.add_headers('User-Agent' => ua)
    # Capybara::Selenium::Driver.new app, opts
    # pp Capybara.current_session.driver.options
    # Capybara.current_session.driver.header('User-Agent' => ua)

  else
    if ua =~ /^(iphone|ipod|ipad|android|android_tablet|windows_phone|black_berry|ie7|ie8|ie9|ie10|chrome)$/
      # ref: https://github.com/mururu/Capybara-user_agent
      set_user_agent eval ':'+ua
    else
      set_custom_user_agent ua
    end
  end
end

# --------------------------------------------------------------------
# クリックアクション
# --------------------------------------------------------------------

step ':labelをクリックする' do |label|
  click_on label
  step 'cap' if autocap
end
step ':labelをクリックする @:scope' do |label, scope|
  within scopeconv(scope) do
    step '"'+label+'"をクリックする'
  end
end

step ':n番目の:labelをクリックする' do |n, label|
  n = n.to_i - 1
  all(:link_or_button, label)[n].click
  step 'cap' if autocap
end
step ':n番目の:labelをクリックする @:scope' do |n, label, scope|
  within scopeconv(scope) do
    step '"'+n+'"番目の"'+label+'"をクリックする'
  end
end

step 'セレクタ:selectorをクリックする' do |selector|
  find(selector).click
  step 'cap' if autocap
end
step 'セレクタ:selectorをクリックする @:scope' do |selector, scope|
  within scopeconv(scope) do
    step 'セレクタ"'+selector+'"をクリックする'
  end
end

# --------------------------------------------------------------------
# フォーム要素：アクション
# --------------------------------------------------------------------

# -- input=text
step 'テキストボックス:nameを:valueにする' do |name, value|
  fill_in name, :with => multi(value)
  step 'cap' if autocap
end
step 'テキストボックス:nameを:valueにする @:scope' do |name, value, scope|
  within scopeconv(scope) do
    step 'テキストボックス"'+name+'"を"'+value+'"にする'
  end
end

# -- textarea
step 'テキストエリア:nameを:valueにする' do |name, value|
  step 'テキストボックス"'+name+'"を"'+value+'"にする'
end
step 'テキストエリア:nameを:valueにする @:scope' do |name, value, scope|
  within scopeconv(scope) do
    step 'テキストボックス"'+name+'"を"'+value+'"にする'
  end
end

# -- radio
step 'ラジオボタン:valueを選択する' do |value|
  choose value
  step 'cap' if autocap
end
step 'ラジオボタン:valueを選択する @:scope' do |value, scope|
  within scopeconv(scope) do
    step 'ラジオボタン"'+value+'"を選択する'
  end
end
step 'ラジオボタン:nameの:valueを選択する' do |name, value|
  find("input[name='"+name+"'][value='"+value+"']").set(true)
  step 'cap' if autocap
end
step 'ラジオボタン:nameの:valueを選択する @:scope' do |name, value, scope|
  within scopeconv(scope) do
    find("input[name='"+name+"'][value='"+value+"']").set(true)
    step 'cap' if autocap
  end
end

# -- checkbox
step 'チェックボックス:valueを選択する' do |value|
  check value
  step 'cap' if autocap
end
step 'チェックボックス:valueを選択する @:scope' do |value, scope|
  within scopeconv(scope) do
    step 'チェックボックス"'+value+'"を選択する'
  end
end
step 'チェックボックス:nameの:valueを選択する' do |name, value|
  find("input[name='"+name+"'][value='"+value+"']").set(true)
  step 'cap' if autocap
end
step 'チェックボックス:nameの:valueを選択する @:scope' do |name, value, scope|
  within scopeconv(scope) do
    find("input[name='"+name+"'][value='"+value+"']").set(true)
    step 'cap' if autocap
  end
end

step 'チェックボックス:valueを未選択にする' do |value|
  uncheck value
  step 'cap' if autocap
end
step 'チェックボックス:valueを未選択にする @:scope' do |value, scope|
  within scopeconv(scope) do
    step 'チェックボックス"'+value+'"を未選択にする'
  end
end
step 'チェックボックス:nameの:valueを未選択にする' do |name, value|
  find("input[name='"+name+"'][value='"+value+"']").set(false)
  step 'cap' if autocap
end
step 'チェックボックス:nameの:valueを未選択にする @:scope' do |name, value, scope|
  within scopeconv(scope) do
    find("input[name='"+name+"'][value='"+value+"']").set(false)
    step 'cap' if autocap
  end
end

# -- select
step 'セレクトボックス:nameの:valueを選択する' do |name, value|
  select value, from: name
  step 'cap' if autocap
end
step 'セレクトボックス:nameの:valueを選択する @:scope' do |name, value, scope|
  within scopeconv(scope) do
    step 'セレクトボックス"'+name+'"の"'+value+'"を選択する'
  end
end

step 'ファイル選択:nameに:filenameを選択する' do |name, filename|
  page.attach_file(name, '/spec/resources/'+filename)
  step 'cap' if autocap
end
step 'ファイル選択:nameに:filenameを選択する @:scope' do |name, filename, scope|
  within scopeconv(scope) do
    step 'ファイル選択"'+name+'"に"'+filename+'"を選択する'
  end
end

# -- hidden
step '隠し要素:nameを:valueにする' do |name, value|
  find('input[name='+name+']', visible: false).set(value)
  step 'cap' if autocap
end
step '隠し要素:nameを:valueにする @:scope' do |name, value, scope|
  within scopeconv(scope) do
    step '隠し要素"'+name+'"を"'+value+'"にする'
  end
end

# --------------------------------------------------------------------
# フォーム：確認
# --------------------------------------------------------------------

# -- input=text
step 'テキストボックス:nameが:valueである' do |name, value|
  expect(page).to have_field name, with: multi(value)
end
step 'テキストボックス:nameが:valueである @:scope' do |name, value, scope|
  within scopeconv(scope) do
    step 'テキストボックス"'+name+'"が"'+value+'"である'
  end
end

step 'テキストボックス:nameが:valueではない' do |name, value|
  expect(page).not_to have_field name, with: multi(value)
end
step 'テキストボックス:nameが:valueではない @:scope' do |name, value, scope|
  within scopeconv(scope) do
    step 'テキストボックス"'+name+'"が"'+value+'"ではない'
  end
end

# -- textarea
step 'テキストエリア:nameが:valueである' do |name, value|
  textarea = find('textarea[name="'+name+'"]')
  expect(textarea.value).to match multi(value)
end
step 'テキストエリア:nameが:valueである @:scope' do |name, value, scope|
  within scopeconv(scope) do
    step 'テキストエリア"'+name+'"が"'+value+'"ではない'
  end
end

step 'テキストエリア:nameが:valueではない' do |name, value|
  textarea = find('textarea[name="'+name+'"]')
  expect(textarea.value).not_to match multi(value)
end
step 'テキストエリア:nameが:valueではない @:scope' do |name, value, scope|
  within scopeconv(scope) do
    step 'テキストエリア"'+name+'"が"'+value+'"ではない'
  end
end

# -- radio
step 'ラジオボタン:valueが選択されている' do |value|
  expect(page).to have_checked_field(value)
end
step 'ラジオボタン:valueが選択されている @:scope' do |value, scope|
  within scopeconv(scope) do
    step 'ラジオボタン"'+value+'"が選択されている'
  end
end
step 'ラジオボタン:nameの:valueが選択されている' do |name, value|
  expect(page).to have_checked_field(name, with: value)
end
step 'ラジオボタン:nameの:valueが選択されている @:scope' do |name, value, scope|
  within scopeconv(scope) do
    step 'ラジオボタン"'+name+'"の"'+value+'"が選択されている'
  end
end

step 'ラジオボタン:valueが選択されていない' do |value|
  expect(page).not_to have_checked_field(value)
end
step 'ラジオボタン:valueが選択されていない @:scope' do |value, scope|
  within scopeconv(scope) do
    step 'ラジオボタン"'+value+'"が選択されていない'
  end
end

step 'ラジオボタン:nameの:valueが選択されていない' do |name, value|
  expect(page).not_to have_checked_field(name, with: value)
end
step 'ラジオボタン:nameの:valueが選択されていない @:scope' do |name, value, scope|
  within scopeconv(scope) do
    step 'ラジオボタン"'+name+'"の"'+value+'"が選択されていない'
  end
end

# -- checkbox
step 'チェックボックス:valueが選択されている' do |value|
  expect(page).to have_checked_field(value)
end
step 'チェックボックス:valueが選択されている @:scope' do |value, scope|
  within scopeconv(scope) do
    step 'チェックボックス"'+value+'"が選択されている'
  end
end
step 'チェックボックス:nameの:valueが選択されている' do |name, value|
  expect(page).to have_checked_field(name, with: value)
end
step 'チェックボックス:nameの:valueが選択されている @:scope' do |name, value, scope|
  within scopeconv(scope) do
    step 'チェックボックス"'+name+'"の"'+value+'"が選択されている'
  end
end

step 'チェックボックス:valueが選択されていない' do |value|
  expect(page).not_to have_checked_field(value)
end
step 'チェックボックス:valueが選択されていない @:scope' do |value, scope|
  within scopeconv(scope) do
    step 'チェックボックス"'+value+'"が選択されていない'
  end
end
step 'チェックボックス:nameの:valueが選択されていない' do |name, value|
  expect(page).not_to have_checked_field(name, with: value)
end
step 'チェックボックス:nameの:valueが選択されていない @:scope' do |name, value, scope|
  within scopeconv(scope) do
    step 'チェックボックス"'+name+'"の"'+value+'"が選択されていない'
  end
end

# -- select
step 'セレクトボックス:nameの:valueが選択されている' do |name, value|
  expect(page).to have_select(name, selected: value)
end
step 'セレクトボックス:nameの:valueが選択されている @:scope' do |name, value, scope|
  within scopeconv(scope) do
    step 'セレクトボックス"'+name+'"の"'+value+'"が選択されている'
  end
end

step 'セレクトボックス:nameの:valueが選択されていない' do |name, value|
  expect(page).not_to have_select(name, selected: value)
end
step 'セレクトボックス:nameの:valueが選択されていない @:scope' do |name, value, scope|
  within scopeconv(scope) do
    step 'セレクトボックス"'+name+'"の"'+value+'"が選択されていない'
  end
end

# -- hidden
step '隠し要素:nameが:valueである' do |name, value|
  expect(find('input[name='+name+']', visible: false).value).to eq value
end
step '隠し要素:nameが:valueである @:scope' do |name, value, scope|
  within scopeconv(scope) do
    step '隠し要素"'+name+'"が"'+value+'"である'
  end
end

step '隠し要素:nameが:valueではない' do |name, value|
  expect(find('input[name='+name+']', visible: false).value).not_to eq value
end
step '隠し要素:nameが:valueではない @:scope' do |name, value, scope|
  within scopeconv(scope) do
    step '隠し要素"'+name+'"が"'+value+'"ではない'
  end
end

# --------------------------------------------------------------------
# HTML要素：アクション
# --------------------------------------------------------------------

step 'セレクタ:selectorをクリックする' do |selector|
  page.execute_script "$('"+selector+"').get(0).click();"
  step 'cap' if autocap
end
step 'セレクタ:selectorをクリックする @:scope' do |selector, scope|
  within scopeconv(scope) do
    step 'セレクタ"'+selector+'"をクリックする'
  end
end

step 'セレクタ:selectorを削除する' do |selector|
  page.execute_script "$('"+selector+"').remove();"
  step 'cap' if autocap
end
step 'セレクタ:selectorを削除する @:scope' do |selector, scope|
  within scopeconv(scope) do
    step 'セレクタ"'+selector+'"を削除する'
  end
end

step 'JS:scriptを実行する' do |script|
  page.execute_script script
  step 'cap' if autocap
end

# --------------------------------------------------------------------
# HTML要素：確認
# --------------------------------------------------------------------

step ':textと表示されている' do |text|
  expect(page).to have_content(multi(text))
end
step ':textと表示されている @:scope' do |text, scope|
  within scopeconv(scope) do
    step '"'+text+'"と表示されている'
  end
end

step ':textと表示されていない' do |text|
  expect(page).not_to have_content(multi(text))
end
step ':textと表示されていない @:scope' do |text, scope|
  within scopeconv(scope) do
    step '"'+text+'"と表示されていない'
  end
end

step ':textというリンクが表示されている' do |text|
  expect(page).to have_link(multi(text))
end
step ':textというリンクが表示されている @:scope' do |text, scope|
  within scopeconv(scope) do
    step '"'+text+'"というリンクが表示されている'
  end
end

step ':textというリンクが表示されていない' do |text|
  expect(page).not_to have_link(multi(text))
end
step ':textというリンクが表示されていない @:scope' do |text, scope|
  within scopeconv(scope) do
    step '"'+text+'"というリンクが表示されていない'
  end
end

step 'セレクタ:selectorが表示されている' do |selector|
  expect(page).to have_css(selector)
end
step 'セレクタ:selectorが表示されている @:scope' do |selector, scope|
  within scopeconv(scope) do
    step 'セレクタ"'+selector+'"が表示されている'
  end
end

step 'セレクタ:selectorが表示されていない' do |selector|
  expect(page).not_to have_css(selector)
end
step 'セレクタ:selectorが表示されていない @:scope' do |selector, scope|
  within scopeconv(scope) do
    step 'セレクタ"'+selector+'"が表示されていない'
  end
end

step 'セレクタ:selectorが存在している' do |selector|
  expect(page).to have_css(selector, visible: false)
end
step 'セレクタ:selectorが存在している @:scope' do |selector, scope|
  within scopeconv(scope) do
    step 'セレクタ"'+selector+'"が存在している'
  end
end

step 'セレクタ:selectorが存在していない' do |selector|
  expect(page).not_to have_css(selector, visible: false)
end
step 'セレクタ:selectorが存在していない @:scope' do |selector, scope|
  within scopeconv(scope) do
    step 'セレクタ"'+selector+'"が存在していない'
  end
end

step 'セレクタ:selectorに:textが表示されている' do |selector, text|
  expect(page).to have_selector(selector, text: text)
end
step 'セレクタ:selectorに:textが表示されている @:scope' do |selector, text, scope|
  within scopeconv(scope) do
    step 'セレクタ"'+selector+'"に"'+text+'"が表示されている'
  end
end

step 'セレクタ:selectorに:textが表示されていない' do |selector, text|
  expect(page).to have_selector(selector, text: text)
end
step 'セレクタ:selectorに:textが表示されていない @:scope' do |selector, text, scope|
  within scopeconv(scope) do
    step 'セレクタ"'+selector+'"に"'+text+'"が表示されていない'
  end
end

step 'ボタン:textが表示されている' do |text|
  expect(page).to have_button(text)
end
step 'ボタン:textが表示されている @:scope' do |text, scope|
  within scopeconv(scope) do
    step 'ボタン"'+text+'"が表示されている'
  end
end

step 'ボタン:textが表示されていない' do |text|
  expect(page).not_to have_button(text)
end
step 'ボタン:textが表示されていない @:scope' do |text, scope|
  within scopeconv(scope) do
    step 'ボタン"'+text+'"が表示されていない'
  end
end

step 'セレクタ:selectorが無効である' do |selector|
  expect(find(selector)).to be_disabled
end
step 'セレクタ:selectorが無効である @:scope' do |selector, scope|
  within scopeconv(scope) do
    step 'セレクタ"'+selector+'"が無効である'
  end
end

step 'セレクタ:selectorが無効ではない' do |selector|
  expect(find(selector)).not_to be_disabled
end
step 'セレクタ:selectorが無効ではない @:scope' do |selector, scope|
  within scopeconv(scope) do
    step 'セレクタ"'+selector+'"が無効ではない'
  end
end

# --------------------------------------------------------------------
# メタ要素：確認
# --------------------------------------------------------------------

step 'ページタイトルが:textである' do |text|
  expect(page.title).to eq text
end

step 'ページタイトルが:textではない' do |text|
  expect(page.title).not_to eq text
end

# --------------------------------------------------------------------
# 一括ページ検証
# --------------------------------------------------------------------
step 'ページを検証する' do |table|
  table.each do |item|
    (type, value, option) = item
    case type
      when 'URL'
        step 'URLが"'+value+'"である'
      when 'PATH'
        step 'パスが'+(option == "unescaped" ? 'エスケープされていない' : '')+'"'+value+'"である'
      when 'TITLE'
        step 'ページタイトルが"'+value+'"である'
      when '!TITLE'
        step 'ページタイトルが"'+value+'"ではない'
      when 'WORD'
        step '"'+value+'"と表示されている'+(option ? ' @"'+option+'"' : '')
      when '!WORD'
        step '"'+value+'"と表示されていない'+(option ? ' @"'+option+'"' : '')
      when 'LINK'
        step '"'+value+'"というリンクが表示されている'+(option ? ' @"'+option+'"' : '')
      when '!LINK'
        step '"'+value+'"というリンクが表示されていない'+(option ? ' @"'+option+'"' : '')
      when 'SELECTOR'
        step 'セレクタ"'+value+'"が'+(option=="false" ? '存在している' : '表示されている')
      when '!SELECTOR'
        step 'セレクタ"'+value+'"が'+(option=="false" ? 'が存在していない' : 'が表示されていない')
      when 'BUTTON'
        step 'ボタン"'+value+'"が表示されている'
      when '!BUTTON'
        step 'ボタン"'+value+'"が表示されていない'
    end
  end
end

# --------------------------------------------------------------------
# 一括フォーム送信
# --------------------------------------------------------------------
step 'フォームを送信する' do |table|
  table.each do |item|
    (type, name, value, scope) = item
    case type
      when 'TEXTBOX'
        step 'テキストボックス"'+name+'"を"'+value+'"にする'+(scope ? ' @"'+scope+'"' : '')
      when 'TEXTAREA'
        step 'テキストエリア"'+name+'"を"'+value+'"にする'+(scope ? ' @"'+scope+'"' : '')
      when 'RADIO'
        step 'ラジオボタン"'+name+'"の"'+value+'"を選択する'+(scope ? ' @"'+scope+'"' : '')
      when 'CHECK'
        step 'チェックボックス"'+name+'"の"'+value+'"を選択する'+(scope ? ' @"'+scope+'"' : '')
      when '!CHECK'
        step 'チェックボックス"'+name+'"の"'+value+'"を未選択にする'+(scope ? ' @"'+scope+'"' : '')
      when 'SELECT'
        step 'セレクトボックス"'+name+'"の"'+value+'"を選択する'+(scope ? ' @"'+scope+'"' : '')
      when 'FILE'
        step 'ファイル選択"'+name+'"に"'+value+'"を選択する'+(scope ? ' @"'+scope+'"' : '')
      when 'HIDDEN'
        step '隠し要素"'+name+'"を"'+value+'"にする'+(scope ? ' @"'+scope+'"' : '')
      when 'SLEEP'
        step '"'+name+'"秒待つ'
      when 'SUBMIT'
        autocap_addname = ' before-submit'
        step 'cap' if autocap
        step '"'+value+'"をクリックする'+(scope ? ' @"'+scope+'"' : '')
        return
    end
  end
  step 'cap' if autocap
end

# --------------------------------------------------------------------
# 一括フォーム入力
# --------------------------------------------------------------------
step 'フォームを入力する' do |table|
  step 'フォームを送信する', table
end

# --------------------------------------------------------------------
# 一括フォーム検証
# --------------------------------------------------------------------
step 'フォームを検証する' do |table|
  table.each do |item|
    (type, name, value, scope) = item
    case type
      when 'TEXTBOX'
        step 'テキストボックス"'+name+'"が"'+value+'"である'+(scope ? ' @"'+scope+'"' : '')
      when '!TEXTBOX'
        step 'テキストボックス"'+name+'"が"'+value+'"ではない'+(scope ? ' @"'+scope+'"' : '')
      when 'TEXTAREA'
        step 'テキストエリア"'+name+'"が"'+value+'"である'+(scope ? ' @"'+scope+'"' : '')
      when '!TEXTAREA'
        step 'テキストエリア"'+name+'"が"'+value+'"ではない'+(scope ? ' @"'+scope+'"' : '')
      when 'RADIO'
        step 'ラジオボタン"'+name+'"の"'+value+'"が選択されている'+(scope ? ' @"'+scope+'"' : '')
      when '!RADIO'
        step 'ラジオボタン"'+name+'"の"'+value+'"が選択されていない'+(scope ? ' @"'+scope+'"' : '')
      when 'CHECK'
        step 'チェックボックス"'+name+'"の"'+value+'"が選択されている'+(scope ? ' @"'+scope+'"' : '')
      when '!CHECK'
        step 'チェックボックス"'+name+'"の"'+value+'"が選択されていない'+(scope ? ' @"'+scope+'"' : '')
      when 'SELECT'
        step 'セレクトボックス"'+name+'"の"'+value+'"が選択されている'+(scope ? ' @"'+scope+'"' : '')
      when '!SELECT'
        step 'セレクトボックス"'+name+'"の"'+value+'"が選択されていない'+(scope ? ' @"'+scope+'"' : '')
      when 'HIDDEN'
        step '隠し要素"'+name+'"が"'+value+'"である'+(scope ? ' @"'+scope+'"' : '')
      when '!HIDDEN'
        step '隠し要素"'+name+'"が"'+value+'"ではない'+(scope ? ' @"'+scope+'"' : '')
    end
  end
end

# --------------------------------------------------------------------
# 一括リンク検証
# --------------------------------------------------------------------
step 'リンクを検証する' do |table|
  table.each do |item|
    (label, href, scope) = item
    if scope then
      within scopeconv(scope) do
        expect(page).to have_link multi(label), href: href
      end
    else
      expect(page).to have_link multi(label), href: href
    end
  end
end

# --------------------------------------------------------------------
# 配送メールの内容を表示する
# --------------------------------------------------------------------
step '最後から:last番目のメールを表示する' do |last|
  visit ('http://localhost:'+(ENV['GENIE_SENDLOG_BIND_PORTS'].split(':')[0])+'/?last='+last)
  step 'cap' if autocap
end
step '最後のメールを表示する' do
  step '最後から"1"番目のメールを表示する'
end
step 'メールを表示する' do
  step '最後から"1"番目のメールを表示する'
end
step 'メールを表示する :last' do |last|
  step '最後から"'+last+'"番目のメールを表示する'
end

# --------------------------------------------------------------------
# 配送メールの内容を検証する
# --------------------------------------------------------------------
step '最後から:last番目のメールを検証する' do |last, table|
  visit ('http://localhost:'+(ENV['GENIE_SENDLOG_BIND_PORTS'].split(':')[0])+'/?last='+last)
  step 'cap' if autocap
  table.each do |item|
    (id, string) = item
    step '"'+string+'"と表示されている @"#'+id+'"'
  end
end
step '最後のメールを検証する' do |table|
  step '最後から"1"番目のメールを検証する', table
end
step 'メールを検証する' do |table|
  step '最後から"1"番目のメールを検証する', table
end
step 'メールを検証する :last' do |last, table|
  step '最後から"'+last+'"番目のメールを検証する', table
end

# --------------------------------------------------------------------
# キーを押す
# ex) * キー"1234-1234-1234-1234"を押す @"[name=account]"
# --------------------------------------------------------------------
step 'キー:keysを押す @:target' do |keys, target|
  find(target).native.send_key(keys)
end

# --------------------------------------------------------------------
# 特殊キーを押す
# ex) * 特殊キー"Enter"を押す @"[name=account]"
# キーマップ：https://github.com/ariya/phantomjs/commit/cab2635e66d74b7e665c44400b8b20a8f225153a
# --------------------------------------------------------------------
step '特殊キー:key_idを押す @:target' do |key_id, target|
  find(target).native.send_key(eval(':'+key_id))
end
