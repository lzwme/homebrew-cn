cask "yaak" do
  arch arm: "aarch64", intel: "x64"

  version "2024.11.3"
  sha256 arm:   "6679bd754cd85ce77bde1fd06b8c521f0ecc34534fd715f9cd61882ed0cc3bcb",
         intel: "041410c646a21e7c50abb58706d2e40f9bae8957db99ee1ca2de7c8b1352be8e"

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