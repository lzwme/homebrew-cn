cask "pixelorama" do
  version "0.11.4"
  sha256 "efd5247ce8700bcd36ff085472a172165051ca65ec8dd2cc0f56a24e79e2dca7"

  url "https:github.comOrama-InteractivePixeloramareleasesdownloadv#{version}Pixelorama.Mac.dmg",
      verified: "github.comOrama-InteractivePixelorama"
  name "Pixelorama"
  desc "2D sprite editor made with the Godot Engine"
  homepage "https:orama-interactive.itch.iopixelorama"

  app "Pixelorama.app"

  zap trash: "~LibrarySaved Application Statecom.orama_interactive.pixelorama.savedState"
end