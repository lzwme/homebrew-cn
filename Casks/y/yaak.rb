cask "yaak" do
  arch arm: "aarch64", intel: "x64"

  version "2025.3.1"
  sha256 arm:   "989d00b7e7455321be1755a2ba947f0e8a597db28a5c934c29fd4b95a95547d5",
         intel: "e5cdbd453571dc980afc4262f5ac48666cdbcc487ee436e335d3c1f3ef12ac3a"

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