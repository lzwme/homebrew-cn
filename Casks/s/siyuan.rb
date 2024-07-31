cask "siyuan" do
  arch arm: "-arm64"

  version "3.1.2"
  sha256 arm:   "05bc6723b2fb204edc8c32e4c44b60ac2774cf09e21c62aeb17d7f6aaf507367",
         intel: "ae859640c3050698c88a9ee7982cada16ac63bd0f8139aef34716530792099c4"

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