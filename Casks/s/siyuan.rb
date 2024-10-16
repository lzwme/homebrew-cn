cask "siyuan" do
  arch arm: "-arm64"

  version "3.1.9"
  sha256 arm:   "9c9b64e65e774b7cf98e03f950f34f25913889f0ad4ad3c246e06bd824aaec6e",
         intel: "23ea5d6e5a56c917359a626f2f0c1f56a3e99f0a3451f354c958e223f87cc5e1"

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