cask "siyuan" do
  arch arm: "-arm64"

  version "3.0.11"
  sha256 arm:   "2b457b687adaf5de8ccaed24234e88c32c432fd5f31faeebd877f154cae83ad5",
         intel: "e863b5703544f83930959dd814d7f239ddca7b42ce02150bbab175db0e347c48"

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