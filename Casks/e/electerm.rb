cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.40.16"
  sha256 arm:   "ad0207793415702aba25c8a7c745803fe52f38e2cdaee1acee281f5afb899553",
         intel: "62f11cf9ba84b722f0c6fd30f27c48cb2081c61f16f4ae11d5bc645ad1635aed"

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