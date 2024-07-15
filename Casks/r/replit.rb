cask "replit" do
  arch intel: "-Intel"

  version "1.0.12"
  sha256 arm:   "c2cfc0c6bfdab45d36981ed8bd4ee247a95b068022e989c22a9eb26f242f5671",
         intel: "b7ae1e249c04dbffb3386e7bcc000af13a96705f284dea8c50ff1509d9a69f61"

  url "https:github.comreplitdesktopreleasesdownloadv#{version}Replit#{arch}.dmg",
      verified: "github.comreplitdesktop"
  name "Replit"
  desc "Software development and deployment platform"
  homepage "https:replit.com"

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Replit.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.electron.replit.*",
    "~LibraryApplication SupportReplit",
    "~LibraryCachescom.electron.replit",
    "~LibraryCachescom.electron.replit.ShipIt",
    "~LibraryHTTPStoragescom.electron.replit",
    "~LibraryLogsReplit",
    "~LibraryPreferencescom.electron.replit.plist",
    "~LibrarySaved Application Statecom.electron.replit.savedState",
  ]
end