cask "passepartout" do
  arch arm: "arm64", intel: "x86_64"

  version "3.4.0"
  sha256 arm:   "6db146edc8026decf86a952b140b3871f9c4a09ed7f231af4c823b8fcb4776c0",
         intel: "e1e51c2af9dc0ddb1ea8c8675fe4006f11cd9de6d5f130055da85661a3e75a50"

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