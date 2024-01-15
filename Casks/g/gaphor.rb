cask "gaphor" do
  version "2.23.2"
  sha256 "da90eecd0a389cb5e115f235fd36030dff484e6b39aab383b2443640fe5c7e7a"

  url "https:github.comgaphorgaphorreleasesdownload#{version}Gaphor-#{version}.dmg",
      verified: "github.comgaphorgaphor"
  name "Gaphor"
  desc "UMLSysML modeling tool"
  homepage "https:gaphor.org"

  depends_on macos: ">= :high_sierra"

  app "Gaphor.app"

  uninstall quit: "Gaphor-#{version}"

  zap trash: [
    "~.cachegaphor",
    "~.localsharegaphor",
  ]
end