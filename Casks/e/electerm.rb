cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.40.18"
  sha256 arm:   "65cefc8f7e7dce9c27fea4ac259e74c92a949420274f57e7a95ed09c494c161a",
         intel: "d7fc2cb39568c8a75f78d37956b01c8d2b2475d25e3cf176ac5e488f51dda72b"

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