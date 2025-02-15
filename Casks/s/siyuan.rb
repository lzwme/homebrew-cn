cask "siyuan" do
  arch arm: "-arm64"

  version "3.1.22"
  sha256 arm:   "1d5d1d68b20ea2f0e45e93b35bb9baa67ce8729b3c5bb8f32320051afa1b3711",
         intel: "e84fbec111d1ba2ccfbbcb08425d0482ea29bb2c7f75221ce306ed6537c5c42f"

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