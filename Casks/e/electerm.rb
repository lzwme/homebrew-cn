cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.38.50"
  sha256 arm:   "984a82d7cc7c81692f65d632418d438e3cb269e7a1f0602195a7e4b5a9ace819",
         intel: "8713c4b52a67c274f414c910b3da0acadc4f91bd3bf97a509c9dcb097fc723e7"

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