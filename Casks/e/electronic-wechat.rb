cask "electronic-wechat" do
  version "2.0"
  sha256 "eba20a9164e917f1a9962fc3202d2c1255a3d26802ae2fd1fe229feaba5b6242"

  url "https:github.comgeeeeeeeeekelectronic-wechatreleasesdownloadV#{version}mac-osx.tar.gz"
  name "Electronic WeChat"
  homepage "https:github.comgeeeeeeeeekelectronic-wechat"

  app "Electronic WeChat-darwin-x64Electronic WeChat.app"

  zap trash: [
    "~LibraryApplication Supportelectronic-wechat",
    "~LibraryApplication Supportelectronic-wechatLocal Storagehttps_web.wechat.com_0.localstorage",
    "~LibraryApplication Supportelectronic-wechatLocal Storagehttps_web.wechat.com_0.localstorage-journal",
    "~LibrarySaved Application Statecom.electron.electronic-wechat.savedState",
    "~LibraryPreferencescom.electron.electronic-wechat.plist",
    "~LibraryPreferencescom.electron.electronic-wechat.helper.plist",
  ]

  caveats do
    discontinued
  end
end