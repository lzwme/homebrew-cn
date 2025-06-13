cask "vscodium" do
  arch arm: "arm64", intel: "x64"

  on_catalina :or_older do
    version "1.97.2.25045"
    sha256 arm:   "c47c8e1df67fdbcbb8318cdccaf8fa4f7716cb2ed5e8359c09319d9a99a1a4b6",
           intel: "1a733b8c254fa63663101c52568b0528085baabe184aae3d34c64ee8ef0142d5"

    livecheck do
      skip "Legacy version"
    end
  end
  on_big_sur :or_newer do
    version "1.101.03933"
    sha256 arm:   "4d1c0b919d2e51e0fd140e883ec67fa4aebbd8882a9a11c7c9c54c13d7795fcd",
           intel: "d66ab33566d91346bb12a6d86cf2b98892b8b51b8a4b49d30dca030ce8a48fb8"

    livecheck do
      url "https:raw.githubusercontent.comVSCodiumversionsrefsheadsmasterstabledarwin#{arch}latest.json"
      strategy :json do |json|
        json["name"]
      end
    end
  end

  url "https:github.comVSCodiumvscodiumreleasesdownload#{version}VSCodium-darwin-#{arch}-#{version}.zip"
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
    "~LibraryCachesVSCodium",
    "~LibraryHTTPStoragescom.vscodium",
    "~LibraryPreferencescom.vscodium*.plist",
    "~LibrarySaved Application Statecom.vscodium.savedState",
  ]
end