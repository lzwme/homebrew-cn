cask "vscodium@insiders" do
  arch arm: "arm64", intel: "x64"

  version "1.98.0.25067-insider"
  sha256 arm:   "6233485688ff628332d4f83fd7af87b929698cefca6266251f0e54e98eccad8b",
         intel: "8cc99f60e1e964eed8da0c37cf1644012f3597ec55013575b76e808813499698"

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