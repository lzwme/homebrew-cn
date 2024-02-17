cask "gaphor" do
  version "2.24.0"
  sha256 "24dc3a3a6752130225a0a36d7e74d25da6f9a0de2e9accde140447ef3a184aba"

  url "https:github.comgaphorgaphorreleasesdownload#{version}Gaphor-#{version}.dmg",
      verified: "github.comgaphorgaphor"
  name "Gaphor"
  desc "UMLSysML modelling tool"
  homepage "https:gaphor.org"

  depends_on macos: ">= :high_sierra"

  app "Gaphor.app"

  uninstall quit: "Gaphor-#{version}"

  zap trash: [
    "~.cachegaphor",
    "~.localsharegaphor",
  ]
end