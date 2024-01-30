cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.38.8"
  sha256 arm:   "45735b1053e7955b1b67b1c1027a9d03c8295b179ab767ee56cd4201d707d436",
         intel: "f153b33fd8442f8207e09e3c4eadd3c1d0916999ee07b48c8fe459f9a9953305"

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