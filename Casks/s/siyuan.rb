cask "siyuan" do
  arch arm: "-arm64"

  version "3.1.18"
  sha256 arm:   "f7ad3886a5fa95c36d0a555c849f9cbbd2972b87db7447cfa2d013d0d00cffb2",
         intel: "0b6b71a643a908bf926febfaab5cdcb3e0b7e1c54fd2de339381370a6c5cb6f5"

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