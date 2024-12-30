cask "netnewswire@beta" do
  version "6.1.8"
  sha256 "ff1872d2017660760154f500970c921f4ff221e94c35e16553b61afc00f1d4d2"

  url "https:github.combrentsimmonsNetNewsWirereleasesdownloadmac-#{version}NetNewsWire#{version}.zip",
      verified: "github.combrentsimmonsNetNewsWire"
  name "NetNewsWire"
  desc "Free and open-source RSS reader"
  homepage "https:ranchero.comnetnewswire"

  livecheck do
    url "https:ranchero.comdownloadsnetnewswire-beta.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  conflicts_with cask: "netnewswire"
  depends_on macos: ">= :ventura"

  app "NetNewsWire.app"

  zap trash: [
    "~LibraryApplication Scriptscom.ranchero.NetNewsWire-Evergreen.Subscribe-to-Feed",
    "~LibraryApplication SupportNetNewsWire",
    "~LibraryCachescom.ranchero.NetNewsWire-Evergreen",
    "~LibraryContainerscom.ranchero.NetNewsWire-Evergreen.Subscribe-to-Feed",
    "~LibraryPreferencescom.ranchero.NetNewsWire-Evergreen.plist",
    "~LibrarySaved Application Statecom.ranchero.NetNewsWire-Evergreen.savedState",
    "~LibraryWebKitcom.ranchero.NetNewsWire-Evergreen",
  ]
end