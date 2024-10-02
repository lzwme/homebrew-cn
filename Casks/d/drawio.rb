cask "drawio" do
  arch arm: "arm64", intel: "x64"

  version "24.7.17"
  sha256 arm:   "466af39487a34c03616fc867e48a4335183d9c66adf36dfdabdbdcf51eba863b",
         intel: "77297eb373f37b7ff9cc1b98ea9cb1077f7af12384fb1ad420ce6fac416e139a"

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
  depends_on macos: ">= :catalina"

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