cask "nota" do
  arch arm: "arm64-mac", intel: "mac"

  version "0.41.0"
  sha256 arm:   "727571f727486376127f0a52b8b460f2bc6ab152e3f2c7377eb7154ef5ec88dd",
         intel: "4ef87e0c7f5cbf796eb6a730569334cc02db76f50ecb06f475847d2ea155ee90"

  url "https:github.comnotaappreleasesreleasesdownload#{version}Nota-#{version}-#{arch}.zip",
      verified: "github.comnotaappreleases"
  name "Nota"
  desc "Markdown files editor"
  homepage "https:nota.md"

  auto_updates true

  app "Nota.app"
  binary "#{appdir}Nota.appContentsResourcesapp.asar.unpackedassetsnota.sh", target: "nota"

  zap trash: [
    "~LibraryApplication SupportNota",
    "~LibraryCachesmd.nota.macos",
    "~LibraryCachesmd.nota.macos.ShipIt",
    "~LibraryLogsNota",
    "~LibraryPreferencesmd.nota.macos.plist",
    "~LibrarySaved Application Statemd.nota.macos.savedState",
  ]
end