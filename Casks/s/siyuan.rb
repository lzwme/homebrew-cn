cask "siyuan" do
  arch arm: "-arm64"

  version "3.0.2"
  sha256 arm:   "357fd40e5dcb90e3314f3eeff4677615fa7992ea99c1c6c59b00e11dd7c449b6",
         intel: "d1d8b3e70931aba6ab0b0e43903da89302bf80c8df5022fc9d483099eeda5cc0"

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