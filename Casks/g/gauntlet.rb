cask "gauntlet" do
  version "19"
  sha256 "9f2eb33db77bfa9d8885b2f6a0a7fd89463bdadffa9f0a7b75f39357a5a556dd"

  url "https:github.comproject-gauntletgauntletreleasesdownloadv#{version}gauntlet-universal-macos.dmg"
  name "Gauntlet"
  desc "Open-source cross-platform application launcher"
  homepage "https:github.comproject-gauntletgauntlet"

  no_autobump! because: :requires_manual_review

  app "Gauntlet.app"

  uninstall quit: "dev.project-gauntlet.Gauntlet"
  uninstall login_item: "Gauntlet"

  zap trash: [
    "~LibraryApplication Supportdev.project-gauntlet.Gauntlet",
    "~LibraryCachesdev.project-gauntlet.Gauntlet",
  ]
end