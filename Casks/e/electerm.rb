cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.37.68"
  sha256 arm:   "60bc043ad9dfc926355fddf7838cb66ea9be9a769d3d9114b2386aa685b77cd6",
         intel: "72f6eea6dd1dc2aa222308358f6d500451ff7eac3b8a37ebbe2f7692c2d438fa"

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