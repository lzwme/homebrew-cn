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
    version "6.1.9"
    sha256 "c06d7f129b0ad423170d333f5a5345041515aba2144a3d06124a98e40cdffe5b"

    url "https:github.comRanchero-SoftwareNetNewsWirereleasesdownloadmac-#{version}NetNewsWire#{version}.zip",
        verified: "github.comRanchero-SoftwareNetNewsWire"

    livecheck do
      url "https:ranchero.comdownloadsnetnewswire-release.xml"
      strategy :sparkle, &:short_version
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
    "~LibraryApplication Scriptscom.ranchero.NetNewsWire-Evergreen*",
    "~LibraryApplication Scriptsgroup.com.ranchero.NetNewsWire-Evergreen",
    "~LibraryApplication SupportNetNewsWire",
    "~LibraryCachescom.ranchero.NetNewsWire-Evergreen",
    "~LibraryContainerscom.ranchero.NetNewsWire-Evergreen*",
    "~LibraryGroup Containersgroup.com.ranchero.NetNewsWire-Evergreen",
    "~LibraryPreferencescom.ranchero.NetNewsWire-Evergreen.plist",
    "~LibrarySaved Application Statecom.ranchero.NetNewsWire-Evergreen.savedState",
    "~LibraryWebKitcom.ranchero.NetNewsWire-Evergreen",
  ]
end