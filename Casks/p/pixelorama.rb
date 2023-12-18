cask "pixelorama" do
  version "0.11.3"
  sha256 "1eb9f411c60701671655e9029243e2448acb513be756243abe87abbb162e653b"

  url "https:github.comOrama-InteractivePixeloramareleasesdownloadv#{version}Pixelorama.Mac.dmg",
      verified: "github.comOrama-InteractivePixelorama"
  name "Pixelorama"
  desc "2D sprite editor made with the Godot Engine"
  homepage "https:orama-interactive.itch.iopixelorama"

  app "Pixelorama.app"

  zap trash: "~LibrarySaved Application Statecom.orama_interactive.pixelorama.savedState"
end