cask "netnewswire" do
  on_monterey :or_older do
    version "6.1.4"
    sha256 "74d75b9e25c6adef06dbf01cd060771872769357448879809535f77493840bbb"

    url "https:github.comRanchero-SoftwareNetNewsWirereleasesdownloadmac-#{version}NetNewsWire#{version}.zip",
        verified: "github.comRanchero-SoftwareNetNewsWire"

    livecheck do
      skip "Legacy version"
    end
  end
  on_ventura :or_newer do
    version "6.1.8"
    sha256 "ff1872d2017660760154f500970c921f4ff221e94c35e16553b61afc00f1d4d2"

    url "https:github.comRanchero-SoftwareNetNewsWirereleasesdownloadmac-#{version}NetNewsWire#{version}.zip",
        verified: "github.comRanchero-SoftwareNetNewsWire"

    livecheck do
      url :url
      regex(^mac[._-]v?(\d+(?:\.\d+)+)(?:[._-]release)?$i)
    end
  end

  name "NetNewsWire"
  desc "Free and open-source RSS reader"
  homepage "https:netnewswire.com"

  auto_updates true
  conflicts_with cask: "netnewswire@beta"
  depends_on macos: ">= :catalina"

  app "NetNewsWire.app"

  zap trash: [
    "~LibraryApplication Scriptscom.ranchero.NetNewsWire-Evergreen",
    "~LibraryApplication Scriptscom.ranchero.NetNewsWire-Evergreen.Subscribe-to-Feed",
    "~LibraryApplication SupportNetNewsWire",
    "~LibraryCachescom.ranchero.NetNewsWire-Evergreen",
    "~LibraryContainerscom.ranchero.NetNewsWire-Evergreen",
    "~LibraryContainerscom.ranchero.NetNewsWire-Evergreen.Subscribe-to-Feed",
    "~LibraryGroup Containersgroup.com.ranchero.NetNewsWire-Evergreen",
    "~LibraryPreferencescom.ranchero.NetNewsWire-Evergreen.plist",
    "~LibrarySaved Application Statecom.ranchero.NetNewsWire-Evergreen.savedState",
    "~LibraryWebKitcom.ranchero.NetNewsWire-Evergreen",
  ]
end