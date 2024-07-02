cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.39.68"
  sha256 arm:   "6379b28f39f00b1039dcc0ffb90c1fc8f0341249f92a33959e75f68706879152",
         intel: "41a0b75d26cad00bb9407045d0df92e796667aacb23201331ecbc555497dc427"

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