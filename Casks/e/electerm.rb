cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.37.121"
  sha256 arm:   "7dcbcf9c9c58529f4159cf8280c63608ce7aa46b0b7694c62fdfbe2efe821a2f",
         intel: "41a7ac976673ae9178319356a0d7f3b3f90f865cb6e9f9a4942eac037c028544"

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