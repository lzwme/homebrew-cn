cask "hstracker" do
  version "3.1.4"
  sha256 "d1ca5d3309f1ebdaf9075306ca3a7bb50677e75e6dc83cf961bba0bfd2477cbf"

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

  caveats do
    requires_rosetta
  end
end