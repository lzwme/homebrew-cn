cask "siyuan" do
  arch arm: "-arm64"

  version "3.0.12"
  sha256 arm:   "b7f9b9bebe38f26863d4db13ec10a7391f373344c0ac99f417430c9afbe289a4",
         intel: "ad297893cb162babfed455ba72e0434442aff846d898163d27cef15e019e57db"

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