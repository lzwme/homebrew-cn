cask "siyuan" do
  arch arm: "-arm64"

  version "2.11.4"
  sha256 arm:   "0bc5a511ee27590874e251b89249e6823217fcabb819e30a014b3239ba1124ba",
         intel: "f39d7b1014c99daf53659db7a679c836c9540bd5828579697d98c3f6b434208f"

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