cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.38.60"
  sha256 arm:   "139c9aa43801a7caba236f86e287a736b39f9d8a86b1b1ed1e53f95896be0dbb",
         intel: "3f60b4baa9dbb12e7997f3aae64b8c0be1fc9c6ab5caab5908950771288d815e"

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