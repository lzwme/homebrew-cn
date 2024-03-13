cask "siyuan" do
  arch arm: "-arm64"

  version "3.0.3"
  sha256 arm:   "c5bf2c85069af5fcc8883bb8d208ec8791c4d2264a3ed7a4ed8a9320acfd844a",
         intel: "1361b7259c25414551cd28a8a9fab701b1c9161a7d057441eb202ae9a6ebc041"

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