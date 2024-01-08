cask "gaphor" do
  version "2.23.0"
  sha256 "5d0a795e1b68ed169faf49d01834c3fea829abb9553e48ec2b0c7b752391d958"

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