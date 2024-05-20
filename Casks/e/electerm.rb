cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.39.18"
  sha256 arm:   "06d5051eb2357509cf9194359db8d5d5d7e519436cc96b599284c86b275992b7",
         intel: "dd41184b86438e816805b668f323f0ab774ca7e3e86ffa648f2df855cbd5cdb4"

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