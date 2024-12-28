cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.51.8"
  sha256 arm:   "fc8d5fc934be3d24d7674fbc8ae25ae9ee2ef6ea819c01708723645c3e4855fa",
         intel: "01a521a0085c42c1ea92c19b08f0c85a809e6d5efdb2cdd6198cbe4cb3a9b1e6"

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