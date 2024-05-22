cask "siyuan" do
  arch arm: "-arm64"

  version "3.0.15"
  sha256 arm:   "78202863d70a978d98df8f24c2c5fa77d27879f322b80699f36802e8a77a9bdd",
         intel: "1d72efc14b3a55e84b9fa203fb8019695c9971aa068e8ff6e374af94de92d9e8"

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