cask "vscodium-insiders" do
  arch arm: "arm64", intel: "x64"

  version "1.85.0.23310-insider"
  sha256 arm:   "a0f0915b0eeed74d4fc17b2dbfcef40665d234c8777a2a67c35f30e99e734f5f",
         intel: "fd6b0e6c6037f89f624580f7f6178761f608d8f5305cc52b6f025c309f06ee24"

  url "https:github.comVSCodiumvscodium-insidersreleasesdownload#{version}VSCodium.#{arch}.#{version}.dmg",
      verified: "github.comVSCodiumvscodium-insiders"
  name "VSCodium"
  name "VSCodium Insiders"
  desc "Code editor"
  homepage "https:vscodium.com"

  depends_on macos: ">= :high_sierra"

  app "VSCodium - Insiders.app"
  binary "#{appdir}VSCodium - Insiders.appContentsResourcesappbincodium-insiders", target: "codium-insiders"

  zap trash: [
    "~.vscodium-insiders",
    "~LibraryApplication SupportVSCodium - Insiders",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.microsoft.vscodiuminsiders.sfl*",
    "~LibraryCachesVSCodium - Insiders",
    "~LibraryCachescom.microsoft.VSCodiumInsiders.ShipIt",
    "~LibraryCachescom.microsoft.VSCodiumInsiders",
    "~LibraryPreferencescom.microsoft.VSCodiumInsiders.helper.plist",
    "~LibraryPreferencescom.microsoft.VSCodiumInsiders.plist",
    "~LibrarySaved Application Statecom.microsoft.VSCodiumInsiders.savedState",
  ]
end