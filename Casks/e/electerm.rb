cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.80.5"
  sha256 arm:   "8b73ca982896951b51ac75f92ab11167d17aeac6dcdba303079fce6b3ea3c34d",
         intel: "9ffdf7f3adf657015eba0589141ba77409667805b6ec8838b98a6ecb156c10da"

  url "https:github.comelectermelectermreleasesdownloadv#{version}electerm-#{version}-mac-#{arch}.dmg"
  name "electerm"
  desc "Terminalsshsftp client"
  homepage "https:github.comelectermelecterm"

  auto_updates true
  depends_on macos: ">= :catalina"

  app "electerm.app"
  binary "#{appdir}electerm.appContentsMacOSelecterm"

  zap trash: [
    "~LibraryApplication Supportelecterm",
    "~LibraryLogselecterm",
    "~LibraryPreferencesorg.electerm.electerm.plist",
    "~LibrarySaved Application Stateorg.electerm.electerm.savedState",
  ]
end