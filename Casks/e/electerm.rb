cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.80.6"
  sha256 arm:   "c5a338e6d3511b0e4695cf0ea5e530913528c36e76bb8de2ea68ab10582ef162",
         intel: "1ea0006c48977b1ff6d6b8a901160edd62df675caca325af8416c8eb88cc43ca"

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