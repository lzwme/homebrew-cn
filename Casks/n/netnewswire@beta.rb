cask "netnewswire@beta" do
  version "6.1.10b2"
  sha256 "44ce377c20123e805f47cdb7e92a3823a597abf473f46cac4c99e32de1362a1b"

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