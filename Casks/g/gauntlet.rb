cask "gauntlet" do
  version "17"
  sha256 "e933bd8d9f9b363e0a07a27cff3ee1e3228b0586a7ebefb306159878dfb9fa1f"

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