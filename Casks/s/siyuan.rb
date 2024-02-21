cask "siyuan" do
  arch arm: "-arm64"

  version "3.0.0"
  sha256 arm:   "86dcb3d35fb73aa4f63b4710b7c3ebdc29dc220176eb4b02ed246404b1416115",
         intel: "69c3302ffd66feb9d58622e9a4b83c272018ca2a458d05f1144efefba76c5540"

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