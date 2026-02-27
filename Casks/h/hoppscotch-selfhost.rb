cask "hoppscotch-selfhost" do
  arch arm: "aarch64", intel: "x64"

  version "26.2.0-0"
  sha256 arm:   "164ab7b214f9ff79eadaee863947a562b18472ce09bc620a2fd522cb6b42b954",
         intel: "7869c3e3a2ba3a0aabd328d4e87c3f002a9778b539e7c08eb7d29da94bd52f87"

  url "https://ghfast.top/https://github.com/hoppscotch/releases/releases/download/v#{version}/Hoppscotch_SelfHost_mac_#{arch}.dmg",
      verified: "github.com/hoppscotch/releases/"
  name "Hoppscotch SelfHost"
  desc "Desktop client for SelfHost version of the Hoppscotch API development ecosystem"
  homepage "https://hoppscotch.com/"

  conflicts_with cask: "hoppscotch"

  app "Hoppscotch.app"

  zap trash: [
    "~/Library/Application Support/io.hoppscotch.desktop",
    "~/Library/Caches/io.hoppscotch.desktop",
    "~/Library/Saved Application State/io.hoppscotch.desktop.savedState",
    "~/Library/WebKit/io.hoppscotch.desktop",
  ]
end