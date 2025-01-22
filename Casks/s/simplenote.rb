cask "simplenote" do
  version "2.23.0"
  sha256 "62bc4a6360a8f1ad3b9c91b663b7d4d5bf0ef87aaa3cef49e0b5c4d8ddc5b3b7"

  url "https:github.comAutomatticsimplenote-electronreleasesdownloadv#{version}Simplenote-macOS-#{version}.dmg"
  name "Simplenote"
  desc "React client for Simplenote"
  homepage "https:github.comAutomatticsimplenote-electron"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "Simplenote.app"

  zap trash: [
    "~LibraryApplication SupportSimplenote",
    "~LibraryCachescom.automattic.simplenote",
    "~LibraryCachescom.automattic.simplenote.ShipIt",
    "~LibrarySaved Application Statecom.automattic.simplenote.savedState",
  ]
end