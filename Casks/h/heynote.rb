cask "heynote" do
  arch arm: "arm64", intel: "x64"

  version "2.1.4"
  sha256 arm:   "bf268697b55ade6d600a3d151bea97f00655fa32b12579e1bbd2960acc3ce7dd",
         intel: "7b965973229a13df5cafcba43d9da60e807d8513bbb294538f3eae77f9cb87df"

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