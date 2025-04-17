cask "vscodium@insiders" do
  arch arm: "arm64", intel: "x64"

  version "1.100.02551-insider"
  sha256 arm:   "1ccee8365c274fc5bcbbb8bce3202c2030e0a95b439002743b38ead60782beed",
         intel: "99416fdaab5b7b4a935a53622010a1170fd2a233592766cfcdce634fb56f9794"

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