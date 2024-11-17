cask "yaak" do
  arch arm: "aarch64", intel: "x64"

  version "2024.12.0"
  sha256 arm:   "dd33e0e6f457d8a36697f5b1e4d4ed2950da2878cb96ffd67805d59460a891a2",
         intel: "dbedc97fc18969d77a3c33027319c9db25b47066c4c8ec6bd55a1af7a0f36f2c"

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