cask "pixelorama" do
  version "1.1.2"
  sha256 "fdd30bb412523979ace21256e50801e13fcccada3f0dc4a0dcb72e166175e6d1"

  url "https:github.comOrama-InteractivePixeloramareleasesdownloadv#{version}Pixelorama-Mac.dmg",
      verified: "github.comOrama-InteractivePixelorama"
  name "Pixelorama"
  desc "2D sprite editor made with the Godot Engine"
  homepage "https:orama-interactive.itch.iopixelorama"

  depends_on macos: ">= :sierra"

  app "Pixelorama.app"

  zap trash: "~LibrarySaved Application Statecom.orama_interactive.pixelorama.savedState"
end