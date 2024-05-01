cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.38.80"
  sha256 arm:   "122910e99a4f68ed81a7597c9a230cb57457dfaf644edca66a74774d29bacdef",
         intel: "73b5fa56bc747c98dda07ba65bfda4eb7d0a480e5ecff1e414dc70e9149e6256"

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