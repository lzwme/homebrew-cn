cask "vscodium" do
  arch arm: "arm64", intel: "x64"

  on_catalina :or_older do
    version "1.97.2.25045"
    sha256 arm:   "48d01a0663b7a6396f41ddc11296eb812d58e9fe3b671b9d33e6b21621e40f21",
           intel: "af8fe5721ef431ab59fe05a06a3a462c40884229f61cc2962ea01d3e66997243"

    livecheck do
      skip "Legacy version"
    end
  end
  on_big_sur :or_newer do
    version "1.99.02289"
    sha256 arm:   "d40ae3a281ea9e04ff9a25024f2f5e8ccaeb322d9402c6ccb8b3ba207db8d6dc",
           intel: "9d87f5a3d08fa3a564789ac08e843b03b3f61aeabd507ac543e412a0bf95dfa8"

    livecheck do
      url :url
      strategy :github_latest
    end
  end

  url "https:github.comVSCodiumvscodiumreleasesdownload#{version}VSCodium.#{arch}.#{version}.dmg"
  name "VSCodium"
  desc "Binary releases of VS Code without MS brandingtelemetrylicensing"
  homepage "https:github.comVSCodiumvscodium"

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