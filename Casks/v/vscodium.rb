cask "vscodium" do
  arch arm: "arm64", intel: "x64"

  version "1.85.1.23348"
  sha256 arm:   "f8faf508690aea341f820b32768ac365eb8a8ace6e47eedb7f62cb68e28bcac8",
         intel: "4cf1e86b22941db6c1f7d07ae0de31c1d1f627b68d0b45bc7d4942b8206a5970"

  url "https:github.comVSCodiumvscodiumreleasesdownload#{version}VSCodium.#{arch}.#{version}.dmg"
  name "VSCodium"
  desc "Binary releases of VS Code without MS brandingtelemetrylicensing"
  homepage "https:github.comVSCodiumvscodium"

  auto_updates true

  app "VSCodium.app"
  binary "#{appdir}VSCodium.appContentsResourcesappbincodium"

  zap trash: [
    "~.vscode-oss",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.visualstudio.code.oss.sfl*",
    "~LibraryApplication SupportVSCodium",
    "~LibraryLogsVSCodium",
    "~LibraryPreferencescom.visualstudio.code.oss.helper.plist",
    "~LibraryPreferencescom.visualstudio.code.oss.plist",
    "~LibrarySaved Application Statecom.visualstudio.code.oss.savedState",
  ]
end