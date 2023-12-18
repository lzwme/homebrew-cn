cask "gaphor" do
  version "2.22.1"
  sha256 "cd761795ed1d0a9fd69feb6ab1be8d1cef4db54e2e25476baf75ede4fd382bb9"

  url "https:github.comgaphorgaphorreleasesdownload#{version}Gaphor-#{version}.dmg",
      verified: "github.comgaphorgaphor"
  name "Gaphor"
  desc "UMLSysML modeling tool"
  homepage "https:gaphor.org"

  app "Gaphor.app"

  uninstall quit: "Gaphor-#{version}"

  zap trash: [
    "~.cachegaphor",
    "~.localsharegaphor",
  ]
end