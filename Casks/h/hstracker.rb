cask "hstracker" do
  version "2.7.2"
  sha256 "b472ab2a695685ce5b1fc59e609fffc42a3a738b760f7c187e17fadf9800be26"

  url "https:github.comHearthSimHSTrackerreleasesdownload#{version}HSTracker.app.zip",
      verified: "github.comHearthSimHSTracker"
  name "Hearthstone Deck Tracker"
  desc "Deck tracker and deck manager for Hearthstone"
  homepage "https:hsdecktracker.net"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  auto_updates true
  depends_on macos: ">= :sierra"

  app "HSTracker.app"

  zap trash: [
    "~LibraryApplication SupportHSTracker",
    "~LibraryApplication Supportnet.hearthsim.hstracker",
    "~LibraryCachesHSTracker",
    "~LibraryCachesnet.hearthsim.hstracker",
    "~LibraryCookiesnet.hearthsim.hstracker.binarycookies*",
    "~LibraryLogsHSTracker",
    "~LibraryPreferencesnet.hearthsim.hstracker.plist",
    "~LibrarySaved Application Statenet.hearthsim.hstracker.savedState",
  ]
end