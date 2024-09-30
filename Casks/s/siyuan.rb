cask "siyuan" do
  arch arm: "-arm64"

  version "3.1.8"
  sha256 arm:   "7895d5855e238ecdd0705a68891df8a2c7853385b3a1e1d44acc8d9c4043d618",
         intel: "3c97a8e675a9f1a3d52b131f40f366839c1eb73ca6c2eb2edfaf27edc0063eb6"

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