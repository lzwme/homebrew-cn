cask "siyuan" do
  arch arm: "-arm64"

  version "2.12.4"
  sha256 arm:   "15bff0a4fe1bfb8290f857192f885526290d151b8e378dd27cc555195b3dab20",
         intel: "266c60e96ba0490ffe0286d047c3bd7474d4b5c70f1aabcc00e00d3a17ad1c2e"

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