cask "quail" do
  version "2.4.0"
  sha256 "481b42f6a2c9ffd94c450f28e49692e95030d11cf20c2823732b117bac1e8992"

  url "https:github.com1000chquailreleasesdownloadv#{version}Quail-#{version}.dmg"
  name "Quail"
  desc "Unofficial but officially accepted esa app"
  homepage "https:github.com1000chquail"

  no_autobump! because: :requires_manual_review

  app "Quail.app"

  zap trash: [
    "~LibraryApplication SupportQuail",
    "~LibraryCachesnet.1000ch.quail",
    "~LibraryCachesnet.1000ch.quail.ShipIt",
    "~LibraryPreferencesnet.1000ch.quail.helper.plist",
    "~LibraryPreferencesnet.1000ch.quail.plist",
    "~LibrarySaved Application Statenet.1000ch.quail.savedState",
  ]

  caveats do
    requires_rosetta
  end
end