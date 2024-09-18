cask "yaak" do
  arch arm: "aarch64", intel: "x64"

  version "2024.9.1"
  sha256 arm:   "1a128f8188dfad93d39adcbbf6c29f24108812eae49b6b43bd8a718d015b91c4",
         intel: "dd4a1c0c4ae29b3769742f2c486611aa2c5aa472aa30d339acce5944da4e2708"

  url "https:github.comyaakappappreleasesdownloadv#{version}Yaak_#{version}_#{arch}.dmg",
      verified: "github.comyaakappapp"
  name "Yaak"
  desc "REST, GraphQL and gRPC client"
  homepage "https:yaak.app"

  livecheck do
    url "https:update.yaak.appcheckdarwin#{arch}0"
    strategy :json do |json|
      json["version"]
    end
  end

  depends_on macos: ">= :high_sierra"

  app "yaak.app"

  zap trash: [
    "~LibraryApplication Supportapp.yaak.desktop",
    "~LibraryCachesapp.yaak.desktop",
    "~LibraryLogsapp.yaak.desktop",
    "~LibrarySaved Application Stateapp.yaak.desktop.savedState",
    "~LibraryWebkitapp.yaak.desktop",
  ]
end