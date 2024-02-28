cask "siyuan" do
  arch arm: "-arm64"

  version "3.0.1"
  sha256 arm:   "e72508bf7e4070c820fb134d5468a9c190f463ea430af5cd838b400e6d7ae6a4",
         intel: "b1b1e1d365c72cf88ca034ffc7d8158900ba9927b953a0be49a7185dc60d4c48"

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