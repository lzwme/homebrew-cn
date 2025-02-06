cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.60.36"
  sha256 arm:   "3c9c25b4d477ae2be834c71019b0de31b8cd271778f2f0e1c42f79fde722c3e4",
         intel: "b7e73695ac06cb51f64b114b5837e82e5bd7c72c34dd5e591e4d242233e746dd"

  url "https:github.comelectermelectermreleasesdownloadv#{version}electerm-#{version}-mac-#{arch}.dmg"
  name "electerm"
  desc "Terminalsshsftp client"
  homepage "https:github.comelectermelecterm"

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "electerm.app"
  binary "#{appdir}electerm.appContentsMacOSelecterm"

  zap trash: [
    "~LibraryApplication Supportelecterm",
    "~LibraryLogselecterm",
    "~LibraryPreferencesorg.electerm.electerm.plist",
    "~LibrarySaved Application Stateorg.electerm.electerm.savedState",
  ]
end