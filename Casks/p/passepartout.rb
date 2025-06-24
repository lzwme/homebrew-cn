cask "passepartout" do
  arch arm: "arm64", intel: "x86_64"

  version "3.5.1"
  sha256 arm:   "d00ffe1e4776fc894117c0f556d1ace9e047462645d490111996786ebfa67aa6",
         intel: "c5149fbe798275ed840f18163997020a102fbdbafab299fcdc563171e98ea915"

  url "https:github.compassepartoutvpnpassepartoutreleasesdownloadv#{version}Passepartout.#{arch}.dmg",
      verified: "github.compassepartoutvpnpassepartout"
  name "Passepartout"
  desc "OpenVPN and WireGuard client"
  homepage "https:passepartoutvpn.app"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :ventura"

  app "Passepartout.app"

  zap trash: [
    "~LibraryApplication Scriptscom.algoritmico.mac.Passepartout",
    "~LibraryApplication ScriptsDTDYD63ZX9.group.com.algoritmico.Passepartout",
    "~LibraryContainerscom.algoritmico.mac.Passepartout",
    "~LibraryGroup ContainersDTDYD63ZX9.group.com.algoritmico.Passepartout",
  ]
end