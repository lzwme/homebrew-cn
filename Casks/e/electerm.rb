cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.60.50"
  sha256 arm:   "9b8c132ed322e1469b2901c9b798408bb70aefb869223548e3fa84e22c02ee7c",
         intel: "7d4f8c180f1eca56429c168d2e9b5fcf650c76a41544c99081eb01427f4e0c59"

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