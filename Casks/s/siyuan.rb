cask "siyuan" do
  arch arm: "-arm64"

  version "2.11.2"
  sha256 arm:   "c84acc38df08e79b4a460f98076b7fe174ecf350dd3c4a9fb1c05ca41956f3bb",
         intel: "31a45e982b698bd9fe80b0513ebd8a49821b3b66ce527dc4e927a60aa802c194"

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