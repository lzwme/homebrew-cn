cask "hstracker" do
  version "3.2.7"
  sha256 "35b331c8daaac0a6d6560c72a07f9a18ae51dff534e95124d4b11f6405aec0f1"

  url "https:github.comHearthSimHSTrackerreleasesdownload#{version}HSTracker.app.zip",
      verified: "github.comHearthSimHSTracker"
  name "Hearthstone Deck Tracker"
  desc "Deck tracker and deck manager for Hearthstone"
  homepage "https:hsdecktracker.net"

  livecheck do
    url "https:hsdecktracker.nethstrackerappcast2.xml"
    strategy :sparkle do |items|
      items.map(&:short_version)
    end
  end

  auto_updates true
  depends_on macos: ">= :mojave"

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