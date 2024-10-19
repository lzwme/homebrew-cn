cask "yaak" do
  arch arm: "aarch64", intel: "x64"

  version "2024.11.4"
  sha256 arm:   "4a3b805483d74ef7ccbc054a08d215766bbf3f25325f2f7d6b61e82476f8be49",
         intel: "8ff5c5f37df3e091a98c915228422f1dbd047b9083fa8c8ec4b255ae3272fadb"

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

  auto_updates true
  depends_on macos: ">= :ventura"

  app "yaak.app"

  zap trash: [
    "~LibraryApplication Supportapp.yaak.desktop",
    "~LibraryCachesapp.yaak.desktop",
    "~LibraryLogsapp.yaak.desktop",
    "~LibrarySaved Application Stateapp.yaak.desktop.savedState",
    "~LibraryWebkitapp.yaak.desktop",
  ]
end