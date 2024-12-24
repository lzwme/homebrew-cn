cask "aide-app" do
  arch arm: "arm64", intel: "x64"

  version "1.94.2.24358"
  sha256 arm:   "f44a366bca4491d02693377850799b510eb37d31b2069dfc33cee7c01c7bca86",
         intel: "38478688bc05fdc0637fa96a1f2a5a953061f571a596b4eafc4746edc2ca978b"

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