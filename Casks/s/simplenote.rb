cask "simplenote" do
  version "2.22.2"
  sha256 "9e5f28c37aa6aefc3056c297e5046b9cdc45e8e66c1ce89a0643bce7558ca271"

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