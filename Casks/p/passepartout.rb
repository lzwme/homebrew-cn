cask "passepartout" do
  arch arm: "arm64", intel: "x86_64"

  version "3.8.1"
  sha256 arm:   "a52bc930dd8531c7108e8a38173a97af05a7c0d6aeb378164163089e27a0060f",
         intel: "77e286b5755e69a55d4c295eaeb806f680c45194a80f954c2c3bbfc8da691630"

  url "https://ghfast.top/https://github.com/passepartoutvpn/passepartout/releases/download/v#{version}/Passepartout.#{arch}.dmg",
      verified: "github.com/passepartoutvpn/passepartout/"
  name "Passepartout"
  desc "OpenVPN and WireGuard client"
  homepage "https://passepartoutvpn.app/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sonoma"

  app "Passepartout.app"

  zap trash: [
    "~/Library/Application Scripts/com.algoritmico.mac.Passepartout",
    "~/Library/Application Scripts/DTDYD63ZX9.group.com.algoritmico.Passepartout",
    "~/Library/Containers/com.algoritmico.mac.Passepartout",
    "~/Library/Group Containers/DTDYD63ZX9.group.com.algoritmico.Passepartout",
  ]
end