cask "drawio" do
  arch arm: "arm64", intel: "x64"

  version "24.4.13"
  sha256 arm:   "fe3110666b0548431e0465f24a7afa547400eef3eba56aa504a224efc355abcb",
         intel: "c54766581f60c28d5dd60ace8618f0fe9935217c7e9a9bc528d58d4cee8ef908"

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