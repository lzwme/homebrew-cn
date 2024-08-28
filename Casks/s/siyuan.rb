cask "siyuan" do
  arch arm: "-arm64"

  version "3.1.4"
  sha256 arm:   "f6c1c96dd6dc36ebbea91f63826d9b173d22ea3635c7ed22c9a0fef70068b1d1",
         intel: "41da9dfe992f407d53a4f0043381820c860cb9918f730596670fdcb7b4c9f1ab"

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