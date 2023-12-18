cask "openbazaar" do
  version "2.4.10"
  sha256 "ba5632071b75ce80c7b1151d0a2e6775d3576e67ea77e36455895e56dc805cad"

  url "https:github.comOpenBazaaropenbazaar-desktopreleasesdownloadv#{version}OpenBazaar#{version.major}-#{version}.dmg",
      verified: "github.comOpenBazaaropenbazaar-desktop"
  name "OpenBazaar#{version.major}"
  homepage "https:www.openbazaar.org"

  app "OpenBazaar#{version.major}.app"

  zap trash: [
    "~LibraryApplication SupportOpenBazaar#{version.major_minor}",
    "~LibraryCachescom.electron.openbazaar#{version.major}",
    "~LibraryCachescom.electron.openbazaar#{version.major}.ShipIt",
    "~LibraryCachescom.electron.openbazaar",
    "~LibraryPreferencescom.electron.openbazaar#{version.major}.helper.plist",
    "~LibraryPreferencescom.electron.openbazaar.plist",
  ]
end