cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.39.109"
  sha256 arm:   "58ac60e732e91b6690c2fcd1895488e9f6ed512420d3a8e72b8a10219c6c76ac",
         intel: "80f51b1c25377af83898eca0657ecf1e546da8aad59ae2508f412ff9d38e571a"

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