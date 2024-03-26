cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.38.41"
  sha256 arm:   "97bdf36bf5b84b1b246980350249f49438c83db9601541f0aadf0853d44fb8dd",
         intel: "6933a543aa54ec0c1f05aa2270355d2a343ceb9b9ae2c3148a91ce9304bd7f5e"

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