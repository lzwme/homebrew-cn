cask "siyuan" do
  arch arm: "-arm64"

  version "2.12.7"
  sha256 arm:   "80379602bd1f454e709e13bca5cba4dd1038dbf25736e3cbaf17bf0c9ebb5738",
         intel: "66670ebc9a4946991685f7c72d6c19e307f0e165f1c207ac9d5a1803f85d41f3"

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