cask "pixelorama" do
  version "1.0.4"
  sha256 "1971f487b06d3a142fe7fe40cfc9f592275b1b428a01020039abdca00b4c23d7"

  url "https:github.comOrama-InteractivePixeloramareleasesdownloadv#{version}Pixelorama-Mac.dmg",
      verified: "github.comOrama-InteractivePixelorama"
  name "Pixelorama"
  desc "2D sprite editor made with the Godot Engine"
  homepage "https:orama-interactive.itch.iopixelorama"

  app "Pixelorama.app"

  zap trash: "~LibrarySaved Application Statecom.orama_interactive.pixelorama.savedState"
end