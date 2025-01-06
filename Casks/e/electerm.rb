cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.51.18"
  sha256 arm:   "eaa2d815e7087eca03f2d78641bb5f154c75366e13d999d56f930b38437d86e7",
         intel: "b8754dde1cc931828c536ab4423b0987cad3558b63a2298e11a8383f99d2f3cc"

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