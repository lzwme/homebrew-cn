cask "siyuan" do
  arch arm: "-arm64"

  version "2.11.3"
  sha256 arm:   "3a8f0efd532253257f57c46d004d512ed3a218812e5149ac0c83e87f336fbdac",
         intel: "2732bb947c6e5ab590f9c2b22ff9007e4b0d35643f253cf6ef83cf21625ff463"

  url "https:github.comsiyuan-notesiyuanreleasesdownloadv#{version}siyuan-#{version}-mac#{arch}.dmg"
  name "SiYuan"
  desc "Local-first personal knowledge management system"
  homepage "https:github.comsiyuan-notesiyuan"

  app "SiYuan.app"

  zap trash: [
    "~.siyuan",
    "~LibraryApplication SupportSiYuan",
    "~LibraryPreferencesorg.b3log.siyuan.plist",
    "~LibrarySaved Application Stateorg.b3log.siyuan.savedState",
  ]
end