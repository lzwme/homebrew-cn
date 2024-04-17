cask "siyuan" do
  arch arm: "-arm64"

  version "3.0.10"
  sha256 arm:   "23998f1d60d70cd1c78010803f41f3459fe722f17a691b839c1c7c8835d333f7",
         intel: "d0c9e66330476ee40f11319bdadbca2ef8149c37f58ac6943083b905693ba1db"

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