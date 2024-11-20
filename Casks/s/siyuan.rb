cask "siyuan" do
  arch arm: "-arm64"

  version "3.1.13"
  sha256 arm:   "76b8f0a8067814f3a50856dfbfb6bad1d53eb496aed3233a7179e83e0ab6a903",
         intel: "638e66d87b812777b1755d577899c71c649e5fddee750847ad88a0b45198adf5"

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