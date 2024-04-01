cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.38.43"
  sha256 arm:   "414836a4d9dfe973d9dd71c55fa61ae9574dbff61a5fe7b102d0d8a24f3f9bb5",
         intel: "cb257d9ee7bf0bbb734ad226741d9771485812db53ca2ea11d18dc82fba440a1"

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