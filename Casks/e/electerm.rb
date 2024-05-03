cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.38.81"
  sha256 arm:   "6e9ca0b01cd2a0379d87d75ada8208ee336c67ca3447c8f687d431996a1e2500",
         intel: "f3d86e01fb4598847ea20fec1c374f5d2df62cb89af6c660d60edf2626f8144c"

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