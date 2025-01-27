cask "vscodium" do
  arch arm: "arm64", intel: "x64"

  version "1.96.4.25026"
  sha256 arm:   "6200a8027bd161d1a4bd3b61e428e79becaa2edc5f3b3862ba7d234d2bec6b6a",
         intel: "0f00a47ae0ea18bbcf067847d69280387a657598bec93b80adc16f6737dc5379"

  url "https:github.comVSCodiumvscodiumreleasesdownload#{version}VSCodium.#{arch}.#{version}.dmg"
  name "VSCodium"
  desc "Binary releases of VS Code without MS brandingtelemetrylicensing"
  homepage "https:github.comVSCodiumvscodium"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "VSCodium.app"
  binary "#{appdir}VSCodium.appContentsResourcesappbincodium"

  zap trash: [
    "~.vscode-oss",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.vscodium.sfl*",
    "~LibraryApplication SupportVSCodium",
    "~LibraryCachescom.vscodium",
    "~LibraryCachescom.vscodium.ShipIt",
    "~LibraryHTTPStoragescom.vscodium",
    "~LibraryPreferencescom.vscodium*.plist",
    "~LibrarySaved Application Statecom.vscodium.savedState",
  ]
end