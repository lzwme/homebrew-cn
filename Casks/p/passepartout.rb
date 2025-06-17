cask "passepartout" do
  arch arm: "arm64", intel: "x86_64"

  version "3.4.2"
  sha256 arm:   "bf431f3a33158a46c65ab87680c4f1722916e15061b98cd376100158d9f56650",
         intel: "e350f5a371c6f2658c115b4d40c51fd1f3751fc9f371e730735d953934dc0ccb"

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