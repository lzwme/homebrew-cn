cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.70.6"
  sha256 arm:   "9829f90a323fe95815b2012ff4fe58d8da949d5fa64412a1c1b6c2e608cd3cae",
         intel: "dac88b00120075292f883151ad8e63e619254c3209d341df9b8f8ab500780734"

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