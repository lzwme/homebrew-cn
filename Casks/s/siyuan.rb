cask "siyuan" do
  arch arm: "-arm64"

  version "3.1.29"
  sha256 arm:   "b701c0a5753616fee80afcf05d7e36bb1b1c78699be5699e18216cd016cf564f",
         intel: "efb073807beb00073ac4cf52abb6c74b5aafed2f608221c8e3d74f789e605988"

  url "https:github.comsiyuan-notesiyuanreleasesdownloadv#{version}siyuan-#{version}-mac#{arch}.dmg"
  name "SiYuan"
  desc "Local-first personal knowledge management system"
  homepage "https:github.comsiyuan-notesiyuan"

  depends_on macos: ">= :catalina"

  app "SiYuan.app"

  zap trash: [
    "~.siyuan",
    "~LibraryApplication SupportSiYuan",
    "~LibraryPreferencesorg.b3log.siyuan.plist",
    "~LibrarySaved Application Stateorg.b3log.siyuan.savedState",
  ]
end