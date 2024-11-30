cask "aide-app" do
  arch arm: "arm64", intel: "x64"

  version "1.94.2.24334"
  sha256 arm:   "d5dff7f4f79e770aba90489923689b40737c5b016639b0e564df89ec27290661",
         intel: "9995f68960d57ae83a0e647ad18656bc920f87a48da691054123c4fd4a6a5493"

  url "https:github.comcodestoryaibinariesreleasesdownload#{version}Aide.#{arch}.#{version}.dmg",
      verified: "github.comcodestoryaibinaries"
  name "Aide"
  desc "Open-source AI-native IDE"
  homepage "https:aide.dev"

  livecheck do
    url "https:aide-updates.codestory.aiapiupdatedarwin-#{arch}stable0"
    strategy :json do |json|
      json["productVersion"]
    end
  end

  auto_updates true
  conflicts_with formula: "aide"
  depends_on macos: ">= :catalina"

  app "Aide.app"
  binary "#{appdir}Aide.appContentsResourcesappbinaide"

  uninstall quit: "ai.codestory.AideInsiders"

  zap trash: [
    "~LibraryApplication Supportai.codestory.sidecar",
    "~LibraryApplication SupportAide",
    "~LibraryCachesai.codestory.AideInsiders",
    "~LibraryCachesai.codestory.AideInsiders.savedState",
    "~LibraryCachesai.codestory.AideInsiders.ShipIt",
    "~LibraryHTTPStoragesai.codestory.AideInsiders",
    "~LibraryPreferencesai.codestory.AideInsiders.plist",
    "~LibraryPreferencesByHostai.codestory.AideInsiders.ShipIt.*.plist",
    "~LibrarySaved Application Stateai.codestory.AideInsiders.savedState",
  ]
end