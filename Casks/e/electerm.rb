cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.38.19"
  sha256 arm:   "a515b990b5662c839283a375900a77913360d75d43d201e3983342002ffb91d6",
         intel: "9ae2592941d58f4d298c1206c1fbb6ab8361f1858d5028f0107939c153098924"

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