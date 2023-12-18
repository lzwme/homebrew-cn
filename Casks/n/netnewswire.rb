cask "netnewswire" do
  version "6.1.4"
  sha256 "74d75b9e25c6adef06dbf01cd060771872769357448879809535f77493840bbb"

  url "https:github.comRanchero-SoftwareNetNewsWirereleasesdownloadmac-#{version}NetNewsWire#{version}.zip",
      verified: "github.comRanchero-SoftwareNetNewsWire"
  name "NetNewsWire"
  desc "Free and open-source RSS reader"
  homepage "https:netnewswire.com"

  livecheck do
    url :url
    regex(^mac[._-]v?(\d+(?:\.\d+)+)$i)
  end

  auto_updates true
  conflicts_with cask: "homebrewcask-versionsnetnewswire-beta"
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