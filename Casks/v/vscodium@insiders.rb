cask "vscodium@insiders" do
  arch arm: "arm64", intel: "x64"

  version "1.100.02844-insider"
  sha256 arm:   "d3f2a93e4dfe5fe34b126dcfa44c2b0b91f98be0c7ef2d1014460a3df86edf37",
         intel: "3c21987c1a0ceead7d8204166acb1a24a5b6cf9798cbbba9574c818e41c5fac4"

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