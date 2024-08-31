cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.39.119"
  sha256 arm:   "cb65fe9afd77313571f489d91c811bca0936cec2a27e79680c35b39d8fd3f68f",
         intel: "75bdf313bd5515526dfa15104f496a8435c9af4eca9005ce48beec60e41bfcef"

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