cask "siyuan" do
  arch arm: "-arm64"

  version "3.1.26"
  sha256 arm:   "14b6a55cb7fa68ad60a2bf4d8e70d2108f6bcd42022d9c2da223c6a4e4a74b00",
         intel: "7d23074bc2e52dda7dc48a190c392eac15d2417c080a562713096fb6a556442c"

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