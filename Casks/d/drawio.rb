cask "drawio" do
  arch arm: "arm64", intel: "x64"

  version "24.2.5"
  sha256 arm:   "1f03f44a7d5f0012f71a20930e0a2d73a905e9ed65e0feac3f7e102d82544224",
         intel: "2b338c631ea9abdb04a792964ee520be2f5cbbfa7bae6856d5253d5b95f4a558"

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