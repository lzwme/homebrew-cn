cask "vscodium" do
  arch arm: "arm64", intel: "x64"

  version "1.96.0.24352"
  sha256 arm:   "3e5aeeaac7891925a25ecfeb22d733a09f59b3764c3117eee049cefa2a6b58e8",
         intel: "5ea17c6eb24d887f1c234798857aedbc8294a0e5440c04e552862ff6f3906eee"

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