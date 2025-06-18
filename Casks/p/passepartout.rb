cask "passepartout" do
  arch arm: "arm64", intel: "x86_64"

  version "3.5.0"
  sha256 arm:   "babfa03c8509590d4aa5be6743a46127d7d458bf6e569c5a6907df8fb5a61de0",
         intel: "bfeade664889ba16f9565f18b5aa18028b7e046720c872fa1382ca58d6b30953"

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