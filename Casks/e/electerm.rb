cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.39.46"
  sha256 arm:   "473b03d83f1537a2eddd88c610953b9532d10512fab5b519da7a5f79dbf10f20",
         intel: "d244bdd235fc25d79255420a37a26c6f2d69e593d7e35cb4be0fa463aa6d0d0d"

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