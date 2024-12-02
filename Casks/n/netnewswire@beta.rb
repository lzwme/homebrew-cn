cask "netnewswire@beta" do
  version "6.1.5b3"
  sha256 "9a8156da34810265ddea7b3d36ca98169eb5ab86407a55efb82b3db5d8b9eb51"

  url "https:github.combrentsimmonsNetNewsWirereleasesdownloadmac-#{version}NetNewsWire#{version}.zip",
      verified: "github.combrentsimmonsNetNewsWire"
  name "NetNewsWire"
  desc "Free and open-source RSS reader"
  homepage "https:ranchero.comnetnewswire"

  livecheck do
    url :url
    regex(^mac-(\d+(?:\.\d+)*b\d+)$i)
  end

  auto_updates true
  conflicts_with cask: "netnewswire"
  depends_on macos: ">= :big_sur"

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