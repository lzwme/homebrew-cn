cask "hstracker" do
  version "3.1.8"
  sha256 "8aaa7322fe7224db93ac972634ee4326487a865e9fb54ef79c83c16b80dc604d"

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