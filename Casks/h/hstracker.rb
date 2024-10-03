cask "hstracker" do
  version "3.0.6"
  sha256 "7cdaf404e07773d4b707ada554e911d8c4cdc7ac081cad23dda0df50441db552"

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