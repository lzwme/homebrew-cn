cask "drawio" do
  arch arm: "arm64", intel: "x64"

  version "22.1.21"
  sha256 arm:   "9cebd6691a41e694e4a5ec2ceed363fee75f3329780df9260d5e5bd366dcae16",
         intel: "5f8ab2e511e10dde16884665af0efc539a7a489bbe4b1503e6bf1277d192c708"

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