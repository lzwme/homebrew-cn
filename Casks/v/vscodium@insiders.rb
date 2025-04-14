cask "vscodium@insiders" do
  arch arm: "arm64", intel: "x64"

  version "1.100.02479-insider"
  sha256 arm:   "86a09eb90453340733befb249d1b0e6514b728017b69196aa1ca4df7327faea2",
         intel: "45142785f8b9bdd659891f4e9ccbdef08d0d263572685978e998faa3836c229b"

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