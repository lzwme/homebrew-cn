cask "aide-app" do
  arch arm: "arm64", intel: "x64"

  version "1.96.2.25009"
  sha256 arm:   "c591567454ae3f4f8ec3bc34df267288f21cbb70f31d70b91ed56748459b2b1e",
         intel: "a77bd2174584ad4856f1a093161b0358caae77245b39d96e7aad057201725ac5"

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