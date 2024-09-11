cask "siyuan" do
  arch arm: "-arm64"

  version "3.1.6"
  sha256 arm:   "88031c268eef2f61dade1d87f1cd27876cc92cd6ac85c068900a5a1a58e3ad8b",
         intel: "813d2541d23c95500485aa2a56116ec735df8def0c4439e8041ff9ec5e7245c0"

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