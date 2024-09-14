cask "pixelorama" do
  version "1.0.3"
  sha256 "cfcc3c0bd32ed8cbb480ccf3abfcffd47eeb84ed1d36070071253653ed36b9af"

  url "https:github.comOrama-InteractivePixeloramareleasesdownloadv#{version}Pixelorama-Mac.dmg",
      verified: "github.comOrama-InteractivePixelorama"
  name "Pixelorama"
  desc "2D sprite editor made with the Godot Engine"
  homepage "https:orama-interactive.itch.iopixelorama"

  app "Pixelorama.app"

  zap trash: "~LibrarySaved Application Statecom.orama_interactive.pixelorama.savedState"
end