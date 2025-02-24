cask "gauntlet" do
  version "16"
  sha256 "7e06ae53a2ee3b6da92daa96a82a171e6faa616a8fe521f90d125f300be368ec"

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