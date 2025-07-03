cask "passepartout" do
  arch arm: "arm64", intel: "x86_64"

  version "3.5.2"
  sha256 arm:   "362e6454c58ba34d08c408306ea00f1b5ff4c90729ea19c12427a1608a80caee",
         intel: "035c5f50311ad11ece1960ecde2f6695c25f89a737f8acbdb5e334d10e42bc29"

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