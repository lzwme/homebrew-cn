cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.50.66"
  sha256 arm:   "94b1e6c939102b4b54042d12defa7353b2332f1da4e119d0e2e4297e1d4ff0ad",
         intel: "6489bf357db829360c6dca877d6f186d7cb263ad486e9a97776f26500f9a8b27"

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