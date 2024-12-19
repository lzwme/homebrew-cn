cask "siyuan" do
  arch arm: "-arm64"

  version "3.1.16"
  sha256 arm:   "e56f77a16b64ecc56fff35c8b9a40927524e4787e22d6de17825b003b6b99af6",
         intel: "ce35e8ce1a98208e5d114c6386d6007a5f32db8d480dc4a3100b47fbe634e1eb"

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