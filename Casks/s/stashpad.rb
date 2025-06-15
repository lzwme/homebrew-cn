cask "stashpad" do
  arch arm: "-arm64"

  version "1.2.28"
  sha256 arm:   "38631d69db2316ca513a4f7331fa3e15248720ea252e596a81e91842791ddd8b",
         intel: "2139046350c14907030700c548b2e6899553baba20fa4cb8c995c717eeb6c068"

  url "https:github.comstashpadsp-desktop-releasereleasesdownloadv#{version}Stashpad-#{version}#{arch}.dmg",
      verified: "github.comstashpadsp-desktop-release"
  name "Stashpad"
  desc "Notes app for collaborative work"
  homepage "https:www.stashpad.com"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :high_sierra"

  app "Stashpad.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.stashpad.app.sfl*",
    "~LibraryApplication SupportStashpad",
    "~LibraryCachesStashpad",
    "~LibraryLogsStashpad",
    "~LibraryPreferencescom.stashpad.app.plist",
    "~LibrarySaved Application Statecom.stashpad.app.savedState",
  ]
end