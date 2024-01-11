cask "siyuan" do
  arch arm: "-arm64"

  version "2.12.2"
  sha256 arm:   "1c58a82a02bcc0dc4ac3bcaabc3b1cb7e1db071fd6929287b9921d70addfebc8",
         intel: "5a60345c8c39d3d4a25b02af6905091041e1562553754050f61cf05c9a4fd754"

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