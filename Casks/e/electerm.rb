cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.39.56"
  sha256 arm:   "0ff585b61dbfeef85616b43394308acca75e4fb47f43d26199a508a2915db9e7",
         intel: "6195caed5ef2941aa5d203c59f568609d0a4f9cb0043a889582f35e52a75975b"

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