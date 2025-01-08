cask "siyuan" do
  arch arm: "-arm64"

  version "3.1.19"
  sha256 arm:   "f593d5e68e5d82e8098cf446ab43026bda1520c4d189c4cc23ac306435b50f04",
         intel: "58115970f7002d5fc94b15d1daa82b1c865af8fa6b69b04105178d6715d6e103"

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