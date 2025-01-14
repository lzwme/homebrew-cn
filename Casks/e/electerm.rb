cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.60.6"
  sha256 arm:   "8f9af2644eb719efe6d0e9718938b853b15a2593625b61d81a04d595c6c2b6c9",
         intel: "79420ae5b52ca0afce2fe2e2fdae2e9bfa0dc933ad4fc6045ba58b53576ab3f2"

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