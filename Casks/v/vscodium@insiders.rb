cask "vscodium@insiders" do
  arch arm: "arm64", intel: "x64"

  version "1.101.03919-insider"
  sha256 arm:   "36a538d76040d3f500c56fb50f2eabff9b0b318b32410a7aaca07e6fe8852bcd",
         intel: "ab75fc803888a0553976fda79891796268177c461e87affe5096b410230e3cc0"

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