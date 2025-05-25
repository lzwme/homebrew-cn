cask "yaak" do
  arch arm: "aarch64", intel: "x64"

  version "2025.2.3"
  sha256 arm:   "5afa0ad75d9127aadbde84d26af9e3b49cf6f91e8881a75289e651028c16a063",
         intel: "297d992883f290988e63e4bdbb7e92025de4fb77e7235947847b302e008d4b73"

  url "https:github.commountain-loopyaakreleasesdownloadv#{version}Yaak_#{version}_#{arch}.dmg",
      verified: "github.commountain-loopyaak"
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
  conflicts_with cask: "yaak@beta"
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