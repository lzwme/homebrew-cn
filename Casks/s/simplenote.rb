cask "simplenote" do
  version "2.22.1"
  sha256 "8c5efd6191d8dab3e49ae9ba0fc488c380211f113d25b2bc6fa30daf47519d07"

  url "https:github.comAutomatticsimplenote-electronreleasesdownloadv#{version}Simplenote-macOS-#{version}.dmg"
  name "Simplenote"
  desc "React client for Simplenote"
  homepage "https:github.comAutomatticsimplenote-electron"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Simplenote.app"

  zap trash: [
    "~LibraryApplication SupportSimplenote",
    "~LibraryCachescom.automattic.simplenote",
    "~LibraryCachescom.automattic.simplenote.ShipIt",
    "~LibrarySaved Application Statecom.automattic.simplenote.savedState",
  ]
end