cask "simplenote" do
  version "2.23.2"
  sha256 "3ea1ae52f355d972c1796401feaaa8486c79acca6cdec6b19230f8db81e34f78"

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