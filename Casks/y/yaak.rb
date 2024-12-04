cask "yaak" do
  arch arm: "aarch64", intel: "x64"

  version "2024.13.0"
  sha256 arm:   "266f5a8d9fef5dc43cb9c6e3531f8458affe3923f7abb33c231a83fa11ee3053",
         intel: "4e9564276f0cd379425e0f24b6d12c9b82dd7ca7cbd257dd7afb2fd4ba089bc0"

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