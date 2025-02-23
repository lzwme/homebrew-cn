cask "gauntlet" do
  version "15"
  sha256 "02c11b5922535efaed2870d4fd1a5cf2b2a56f49c45e80d98f76cdd542d62c02"

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