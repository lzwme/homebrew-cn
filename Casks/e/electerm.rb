cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.60.56"
  sha256 arm:   "8d685bc117ffc2cf30031bb487dd09019b360d41c37298091ed37e29ec10584a",
         intel: "aa6927723af95a0fc1b31a8cbfb36d6db965ec042624452627cae01ae14bb74d"

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