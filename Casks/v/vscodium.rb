cask "vscodium" do
  arch arm: "arm64", intel: "x64"

  version "1.97.0.25037"
  sha256 arm:   "6985346327bd7f8b41dc7ebc87e923d17d7b3b4e5148285eef2e4c92c80a54de",
         intel: "52e8431e1be1d0bb831a320dafbb986dafaea667f89f4fe9e46c930e13e117d8"

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