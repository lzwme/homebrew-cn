cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.50.40"
  sha256 arm:   "bdcd52b9a29b6fe4ce38588a4ce99f4c6c08da4a55701cd685f37f0607948ac0",
         intel: "cad0b518da81e3a17abd17c0f881ed9c2ba2e2203b33a88e272c301c67e9d1e4"

  url "https:github.comelectermelectermreleasesdownloadv#{version}electerm-#{version}-mac-#{arch}.dmg"
  name "electerm"
  desc "Terminalsshsftp client"
  homepage "https:github.comelectermelecterm"

  auto_updates true

  app "electerm.app"
  binary "#{appdir}electerm.appContentsMacOSelecterm"

  zap trash: [
    "~LibraryApplication Supportelecterm",
    "~LibraryLogselecterm",
    "~LibraryPreferencesorg.electerm.electerm.plist",
    "~LibrarySaved Application Stateorg.electerm.electerm.savedState",
  ]
end