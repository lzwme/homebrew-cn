cask "aide-app" do
  arch arm: "arm64", intel: "x64"

  version "1.96.2.25003"
  sha256 arm:   "38945bdae222a968f18da7915cc838696517002470feac922e4f01fd45d072e2",
         intel: "1448763eea13f9ed0ff01ade0ad3880d928f79627834efaa899abf1b77487ec4"

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