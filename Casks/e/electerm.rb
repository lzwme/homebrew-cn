cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.38.11"
  sha256 arm:   "c41062dd446b9dedf6e1c375e5f68d649b68a78a433ca956fa969ddb3ff08fb1",
         intel: "02dc5a1a61c1d33dc68ff5d1c346ac2a4c1951c39779001bd55abffea623e780"

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