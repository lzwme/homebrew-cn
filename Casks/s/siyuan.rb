cask "siyuan" do
  arch arm: "-arm64"

  version "2.12.8"
  sha256 arm:   "51f75c7a97ed74148b1083a2d85aa5f8f286d654dbf614d1041c3aef6652ecd8",
         intel: "fd0516e1b3fe7a65035e6d492e8db5e4c178b7e014950df7782cb43118c4550a"

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