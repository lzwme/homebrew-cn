cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.38.86"
  sha256 arm:   "72a23ad8632d80d43173c08d8383a38568077203c8ea1711a395c1cf9b362789",
         intel: "547ef9a1ab04d9417b65f7a63c1fff1abb1d3e70864c1adbac3fedca361ddd78"

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