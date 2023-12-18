cask "simplenote" do
  version "2.21.0"
  sha256 "431e83a0982414a3932f4e4b408a9ae125f84118be1f810c11a84e2d8c1aa740"

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