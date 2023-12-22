cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.37.80"
  sha256 arm:   "a16de6abeff98d03fb63f83e2ea7f960c7758c7ee930966c44b586efc3de60d6",
         intel: "7af440f24a30744b562e442068089d9c5da722c55bee1b86a201d586646edcfb"

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