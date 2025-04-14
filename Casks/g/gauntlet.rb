cask "gauntlet" do
  version "18"
  sha256 "5e69a19b95cd92634e5baf35cd1947ac2847099395a1a8228ba9f29608a81b24"

  url "https:github.comproject-gauntletgauntletreleasesdownloadv#{version}gauntlet-universal-macos.dmg"
  name "Gauntlet"
  desc "Open-source cross-platform application launcher"
  homepage "https:github.comproject-gauntletgauntlet"

  app "Gauntlet.app"

  uninstall quit: "dev.project-gauntlet.Gauntlet"
  uninstall login_item: "Gauntlet"

  zap trash: [
    "~LibraryApplication Supportdev.project-gauntlet.Gauntlet",
    "~LibraryCachesdev.project-gauntlet.Gauntlet",
  ]
end