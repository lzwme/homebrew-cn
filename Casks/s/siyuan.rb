cask "siyuan" do
  arch arm: "-arm64"

  version "3.1.21"
  sha256 arm:   "c4a373418fa9144377e45b339eb0352cfb2e73101642c4599239dbedceace12c",
         intel: "3f87a36e3b283e6f2f2788cabcc36dba8ea39359bdbb26245d15b1d87d59a9a2"

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