cask "drawio" do
  arch arm: "arm64", intel: "x64"

  version "27.0.2"
  sha256 arm:   "1c7c5cea6b2084b19dfbdaec44dc9c21ad2d4d00a84c1b0ca0bd86e9ae6eae4c",
         intel: "a63fbe4117770fcd3d70256b04efd8869d16e7f60ef3819c0fcec6a4f9cb0983"

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