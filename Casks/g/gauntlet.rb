cask "gauntlet" do
  version "7"
  sha256 "ea3a79121c03647a4bbb0c68654adc40708194327d23c367fdf39f85e5317310"

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