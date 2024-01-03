cask "siyuan" do
  arch arm: "-arm64"

  version "2.12.0"
  sha256 arm:   "d6d10f8d9ac513f522ebc6436055cef6679071d7b5ed7928d22a4ef18e9bc01b",
         intel: "68dc778389b1b4ce703ee3888b0762e9eb5869d097866021c04de5d50bcb5821"

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