cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.39.99"
  sha256 arm:   "dec166ca1d5e5dc23766f6135fb24d6149899a0f40c4a4e2260128113676ebb4",
         intel: "8511164fee0b9ba37abddc70a486b8fee946bd4f9e1e557f6dfef52664db8644"

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