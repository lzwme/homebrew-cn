cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.37.88"
  sha256 arm:   "fc68e3b30683116b8113461681f3ebdb9e7f7c89ffaeb53f4444147ce6de81da",
         intel: "dfd396c41b6da9d5a4a8eaf82a093844b1514b261249fd5dc8fb7ab1affe2640"

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