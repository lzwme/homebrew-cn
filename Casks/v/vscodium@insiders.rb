cask "vscodium@insiders" do
  arch arm: "arm64", intel: "x64"

  version "1.97.0.24352-insider"
  sha256 arm:   "e87fd28efdb53dc5c367bd6d09ca28cdb4ef32a9e4d723b113a77521909d2139",
         intel: "54b3db7eecad0939c74a3a34c6d2563795b2965d84133ceaf88cb68a62089ccc"

  url "https:github.comVSCodiumvscodium-insidersreleasesdownload#{version}VSCodium.#{arch}.#{version}.dmg",
      verified: "github.comVSCodiumvscodium-insiders"
  name "VSCodium"
  name "VSCodium Insiders"
  desc "Code editor"
  homepage "https:vscodium.com"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+.*)$i)
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "VSCodium - Insiders.app"
  binary "#{appdir}VSCodium - Insiders.appContentsResourcesappbincodium-insiders", target: "codium-insiders"

  zap trash: [
    "~.vscodium-insiders",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.vscodium.vscodiuminsiders.sfl*",
    "~LibraryApplication SupportVSCodium - Insiders",
    "~LibraryCachescom.vscodium.VSCodiumInsiders",
    "~LibraryCachescom.vscodium.VSCodiumInsiders.ShipIt",
    "~LibraryCachesVSCodium - Insiders",
    "~LibraryHTTPStoragescom.vscodium.VSCodiumInsiders",
    "~LibraryPreferencescom.vscodium.VSCodiumInsiders*.plist",
    "~LibrarySaved Application Statecom.vscodium.VSCodiumInsiders.savedState",
  ]
end