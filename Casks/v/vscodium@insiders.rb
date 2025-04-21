cask "vscodium@insiders" do
  arch arm: "arm64", intel: "x64"

  version "1.100.02662-insider"
  sha256 arm:   "75b4213395a6df322b517e4e75042b056b046b672901a246e14acffde62184ee",
         intel: "a4087f7ac9bdc8833aac7a2f18b6f61b5b1e3557c4f80612bef5ee4e9bd0afc9"

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