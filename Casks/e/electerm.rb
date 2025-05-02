cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.80.18"
  sha256 arm:   "ad3ad376240b294e22293d94922eb2706fdb8c3cf1255650291cedf849b95092",
         intel: "5abc965e4a0b0ba1d9b293c422852b17d4ebe9ec963feb0e57bd8ab6dde00f91"

  url "https:github.comelectermelectermreleasesdownloadv#{version}electerm-#{version}-mac-#{arch}.dmg"
  name "electerm"
  desc "Terminalsshsftp client"
  homepage "https:github.comelectermelecterm"

  auto_updates true
  depends_on macos: ">= :catalina"

  app "electerm.app"
  binary "#{appdir}electerm.appContentsMacOSelecterm"

  zap trash: [
    "~LibraryApplication Supportelecterm",
    "~LibraryLogselecterm",
    "~LibraryPreferencesorg.electerm.electerm.plist",
    "~LibrarySaved Application Stateorg.electerm.electerm.savedState",
  ]
end