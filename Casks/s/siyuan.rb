cask "siyuan" do
  arch arm: "-arm64"

  version "3.1.10"
  sha256 arm:   "c7b32b810561cff5efd3bba4cb580bf0d2bb8942bebaeaa5b9e807683c4075d9",
         intel: "5d9fc93005ee7d57c1326ba1eb0b5bb86487475b98192395b4337c378bc670a4"

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