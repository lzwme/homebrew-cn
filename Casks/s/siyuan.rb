cask "siyuan" do
  arch arm: "-arm64"

  version "2.12.5"
  sha256 arm:   "8056917f1b65c45034a00e3344ca2ec99d8d72f8f32fd0d449cf4d7a8e43cafa",
         intel: "e484773a9fcd2afe7a2895a3b088becec4f5c9a89ba495baaaf476839e1f3c05"

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