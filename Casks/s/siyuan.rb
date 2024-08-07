cask "siyuan" do
  arch arm: "-arm64"

  version "3.1.3"
  sha256 arm:   "d2a5a70aa4b3fb6ae8f9c023f26f944d0200e11a4e647564e336f74b83522411",
         intel: "f83d0b3e1cc1c0b47f45283015cf5767e5866f547c282f693b55a1157b95b232"

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