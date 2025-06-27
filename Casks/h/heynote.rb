cask "heynote" do
  arch arm: "arm64", intel: "x64"

  version "2.3.1"
  sha256 arm:   "b57014a712db7b572b5d5153f6930863c524a796a9a9f1046f8ea92cbcfe24d5",
         intel: "c17d15ee071e750bd32fe1e770a89461b0d811405e613dd93a81efe99b7fa9d9"

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