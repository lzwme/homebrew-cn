cask "pixelorama" do
  version "1.0.5"
  sha256 "2ec545418e1da67468459dac54e608639c20c223f452277c133155552f8063f3"

  url "https:github.comOrama-InteractivePixeloramareleasesdownloadv#{version}Pixelorama-Mac.dmg",
      verified: "github.comOrama-InteractivePixelorama"
  name "Pixelorama"
  desc "2D sprite editor made with the Godot Engine"
  homepage "https:orama-interactive.itch.iopixelorama"

  depends_on macos: ">= :sierra"

  app "Pixelorama.app"

  zap trash: "~LibrarySaved Application Statecom.orama_interactive.pixelorama.savedState"
end