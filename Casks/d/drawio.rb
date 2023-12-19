cask "drawio" do
  arch arm: "arm64", intel: "x64"

  version "22.1.11"
  sha256 arm:   "6a21fb1d05012877f188f2e97ec749517a751b36118498c63e4e5d73fb85c0bb",
         intel: "4ef46aa3865a0251817bdc94626d596d92170baad239eca048e461623b28957d"

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
    "~LibraryLogsdraw.io",
    "~LibraryPreferencescom.jgraph.drawio.desktop.helper.plist",
    "~LibraryPreferencescom.jgraph.drawio.desktop.plist",
    "~LibrarySaved Application Statecom.jgraph.drawio.desktop.savedState",
    "~LibraryWebKitcom.jgraph.drawio.desktop",
  ]
end