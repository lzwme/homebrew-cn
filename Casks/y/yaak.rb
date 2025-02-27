cask "yaak" do
  arch arm: "aarch64", intel: "x64"

  version "2025.1.2"
  sha256 arm:   "e977fe7c3d686527ba1c1a910d0a701863bd60164234512bce8da4141f8b2e26",
         intel: "59c35812225866a4bbddfc49eb927d9d0d4ab8d8e2e8987340d3adc9ded67b42"

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