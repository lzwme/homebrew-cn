cask "pixelorama" do
  version "1.1.1"
  sha256 "636521d2c2cfc50baef8080d126177a785f1779aa84be365c8d6279d4ea0b58c"

  url "https:github.comOrama-InteractivePixeloramareleasesdownloadv#{version}Pixelorama-Mac.dmg",
      verified: "github.comOrama-InteractivePixelorama"
  name "Pixelorama"
  desc "2D sprite editor made with the Godot Engine"
  homepage "https:orama-interactive.itch.iopixelorama"

  depends_on macos: ">= :sierra"

  app "Pixelorama.app"

  zap trash: "~LibrarySaved Application Statecom.orama_interactive.pixelorama.savedState"
end