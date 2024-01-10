cask "siyuan" do
  arch arm: "-arm64"

  version "2.12.1"
  sha256 arm:   "05b5cfc12bff6124ff3dfd12096547c5d95a22956b62df423d52e1ab5ec374fa",
         intel: "3be19a65aee68a48c1c7f6394e5d064d214f9627c2b238235bc4e3316cabda50"

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