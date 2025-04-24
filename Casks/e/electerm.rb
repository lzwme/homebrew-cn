cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.80.3"
  sha256 arm:   "c026bf341f278c5f25fba0a620fed0799d1a5b6e2ff319b92ab4ec4447cd458f",
         intel: "94269e6537943116ad1e70d2545a33a208c620600e9ce5c16106c897122c47b8"

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