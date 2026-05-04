cask "passepartout" do
  arch arm: "arm64", intel: "x86_64"

  version "3.8.2"
  sha256 arm:   "7c6e1cf98ee1b95ebd11fa7fa247c9df1c16ab56d0cc7870af7c3aa3b48e50a8",
         intel: "72eaa8d467f85a2d247c94e68230b9f691282e05d2c662b6203f3a8440e46de8"

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