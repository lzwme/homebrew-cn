cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.39.2"
  sha256 arm:   "f02f5702720255785d596bbec904e302d0b04314b41ba09eea9d78bba8d054b2",
         intel: "b228a509d82a8586410a988736e7ef42aa842e996080af4c1fbb28fdb0643ad1"

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