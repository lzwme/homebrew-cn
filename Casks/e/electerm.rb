cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.72.36"
  sha256 arm:   "9dcc8fc8d41e638a2be121512fca01112be15f697913b79b3d4a1c6924d96d15",
         intel: "2067580afcf1797d43fca140e8023bbd930794520f3b0bade5b66b4bc0bf23c0"

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