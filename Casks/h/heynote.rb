cask "heynote" do
  arch arm: "arm64", intel: "x64"

  version "2.2.1"
  sha256 arm:   "6c2b8fc006165f714efe960c44cd1bff0031bd1cba00b2159ecbd50f236d8311",
         intel: "3ecf4b174e7e4981b97cbaa79eb13c0771b08e01fd2e3b145c973a061a047838"

  url "https:github.comheymanheynotereleasesdownloadv#{version}Heynote_#{version}_#{arch}.dmg",
      verified: "github.comheymanheynote"
  name "Heynote"
  desc "Dedicated scratchpad for developers"
  homepage "https:heynote.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Heynote.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.heynote.app.sfl*",
    "~LibraryApplication SupportHeynote",
    "~LibraryCachescom.heynote.app",
    "~LibraryCachescom.heynote.app.ShipIt",
    "~LibraryCachesheynote-updater",
    "~LibraryHTTPStoragescom.heynote.app",
    "~LibraryLogsHeynote",
    "~LibraryPreferencesByHostcom.heynote.app.ShipIt.*.plist",
    "~LibraryPreferencescom.heynote.app.plist",
    "~LibrarySaved Application Statecom.heynote.app.savedState",
  ]
end