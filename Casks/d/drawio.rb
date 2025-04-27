cask "drawio" do
  arch arm: "arm64", intel: "x64"

  version "26.2.15"
  sha256 arm:   "2220ee15d8877b62a23c7016ab1af5c98c3c1a18f0ce648318268e99eff8666d",
         intel: "1d956a9c9a7f999e9e34cc8ab9a47b095d886086994a59b0d70b5269b60b3c81"

  url "https:github.comjgraphdrawio-desktopreleasesdownloadv#{version}draw.io-#{arch}-#{version}.dmg",
      verified: "github.comjgraphdrawio-desktop"
  name "draw.io Desktop"
  desc "Online diagram software"
  homepage "https:www.diagrams.net"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "draw.io.app"

  zap trash: [
    "~LibraryApplication Supportdraw.io",
    "~LibraryCachescom.jgraph.drawio.desktop",
    "~LibraryCachescom.jgraph.drawio.desktop.ShipIt",
    "~LibraryCachesdraw.io-updater",
    "~LibraryHTTPStoragescom.jgraph.drawio.desktop",
    "~LibraryLogsdraw.io",
    "~LibraryPreferencesByHostcom.jgraph.drawio.desktop.ShipIt.*.plist",
    "~LibraryPreferencescom.jgraph.drawio.desktop.helper.plist",
    "~LibraryPreferencescom.jgraph.drawio.desktop.plist",
    "~LibrarySaved Application Statecom.jgraph.drawio.desktop.savedState",
    "~LibraryWebKitcom.jgraph.drawio.desktop",
  ]
end