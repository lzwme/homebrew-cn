cask "vscodium@insiders" do
  arch arm: "arm64", intel: "x64"

  version "1.101.03895-insider"
  sha256 arm:   "9634fb54fd75a6157b9ce92c37c0f3cafb0e3ca12a793d6459716259b8b05571",
         intel: "8b5e00bf87007ca33d9bfd2eeee78326599fd38994565808793fdb4e51137c51"

  url "https:github.comVSCodiumvscodium-insidersreleasesdownload#{version}VSCodium-darwin-#{arch}-#{version}.zip",
      verified: "github.comVSCodiumvscodium-insiders"
  name "VSCodium"
  name "VSCodium Insiders"
  desc "Code editor"
  homepage "https:vscodium.com"

  livecheck do
    url "https:raw.githubusercontent.comVSCodiumversionsrefsheadsmasterinsiderdarwin#{arch}latest.json"
    strategy :json do |json|
      json["name"]
    end
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "VSCodium - Insiders.app"
  binary "#{appdir}VSCodium - Insiders.appContentsResourcesappbincodium-insiders"

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