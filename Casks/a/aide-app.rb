cask "aide-app" do
  arch arm: "arm64", intel: "x64"

  version "1.96.2.25016"
  sha256 arm:   "662858c76617858da004f70ced8143323417fcc87baa67bdf2a9b99ee0430000",
         intel: "33bb72d014c41e5186a56654c82282529136340e7fa5f810026c506b01282534"

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