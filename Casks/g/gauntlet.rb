cask "gauntlet" do
  version "14"
  sha256 "24d4c995375a62990d3a48cf6a042d589f2e296ed3029bb827aae6fa7618ad06"

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