cask "whale" do
  version "2.4.0"
  sha256 "63857d17bf6d44c65215d729870737a17153f33c01605dc093626b7185731b02"

  url "https:github.com1000chwhalereleasesdownloadv#{version}Whale-#{version}.dmg"
  name "Whale"
  desc "Unofficial Trello app"
  homepage "https:github.com1000chwhale"

  no_autobump! because: :requires_manual_review

  app "Whale.app"

  zap trash: [
    "~LibraryApplication SupportWhale",
    "~LibraryCachesnet.1000ch.whale",
    "~LibraryCachesnet.1000ch.whale.ShipIt",
    "~LibraryPreferencesnet.1000ch.whale.helper.plist",
    "~LibraryPreferencesnet.1000ch.whale.plist",
    "~LibrarySaved Application Statenet.1000ch.whale.savedState",
  ]

  caveats do
    requires_rosetta
  end
end