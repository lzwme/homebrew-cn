cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.38.65"
  sha256 arm:   "f40d680ff6b4d18dbc7da022f445275bca2f16bfb6cbfd63b67dc1c65758e54b",
         intel: "667acb71d03296a84ddc772c29fb4783116099f85777f59921904bbc053f5c2b"

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