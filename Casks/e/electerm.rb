cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.39.31"
  sha256 arm:   "ec1491d3cd7d3a9fd5ab78d00d16916a1984506a40fd46f06bdded3c4bdad46f",
         intel: "f01e3ff2d8350468db9d1f81de86b1fef5fdf2fafa10cfc3df20cda4d17c735d"

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