cask "gauntlet" do
  version "10"
  sha256 "ecd84c78629af96d768d4c5f588db115a896c3f8b5491983b202488972701968"

  url "https:github.comproject-gauntletgauntletreleasesdownloadv#{version}gauntlet-aarch64-macos.dmg"
  name "Gauntlet"
  desc "Open-source cross-platform application launcher"
  homepage "https:github.comproject-gauntletgauntlet"

  depends_on arch: :arm64

  app "Gauntlet.app"

  uninstall quit: "dev.project-gauntlet.Gauntlet"
  uninstall login_item: "Gauntlet"

  zap trash: [
    "~LibraryApplication Supportdev.project-gauntlet.Gauntlet",
    "~LibraryCachesdev.project-gauntlet.Gauntlet",
  ]
end