cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.40.20"
  sha256 arm:   "58d3c18ccf56b63dbfb9f2320ef5270b315765950bd0f9d21a53d1def578cf73",
         intel: "58041bde1e75f6abefb6855ea6487a0c04aa8ef52624736914b06f0c47bda46d"

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