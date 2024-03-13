cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.38.30"
  sha256 arm:   "65a757da59d816b9cf86e68d85c6f766fdff60838c992dbd88e3bf8784992811",
         intel: "32d01723a0e8742d70d4538439b6bb12a6f9846072e05c6b8bc8ebecc00b238c"

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