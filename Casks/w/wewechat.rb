cask "wewechat" do
  version "1.1.7"
  sha256 "4673347d6192fba598f9e9271ad4dea52f633b8da623056cac84de88d4e72c5e"

  url "https:github.comtrazynweweChatreleasesdownloadv#{version}wewechat-#{version}-mac.dmg"
  name "weweChat"
  desc "Unofficial WeChat client"
  homepage "https:github.comtrazynweweChat"

  app "wewechat.app"

  zap trash: [
    "~LibraryApplication Supportwewechat",
    "~LibraryPreferencesgh.trazyn.wewechat.helper.plist",
    "~LibraryPreferencesgh.trazyn.wewechat.plist",
    "~LibrarySaved Application Stategh.trazyn.wewechat.savedState",
  ]
end