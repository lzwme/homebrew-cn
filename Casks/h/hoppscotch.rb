cask "hoppscotch" do
  arch arm: "aarch64", intel: "x64"

  version "26.2.0-0"
  sha256 arm:   "69296566f7ddc7cd0c9ea03b13285a4683167b0b4a834996e775510bd2130672",
         intel: "2a921f6e05a56cf0f4f4d80977c8e1eb38460761a159333d0bf2a8f005ad98ac"

  url "https://ghfast.top/https://github.com/hoppscotch/releases/releases/download/v#{version}/Hoppscotch_mac_#{arch}.dmg",
      verified: "github.com/hoppscotch/releases/"
  name "Hoppscotch"
  desc "Open source API development ecosystem"
  homepage "https://hoppscotch.com/"

  conflicts_with cask: "hoppscotch-selfhost"

  app "Hoppscotch.app"

  zap trash: [
    "~/Library/Application Support/io.hoppscotch.desktop",
    "~/Library/Caches/io.hoppscotch.desktop",
    "~/Library/Saved Application State/io.hoppscotch.desktop.savedState",
    "~/Library/WebKit/io.hoppscotch.desktop",
  ]
end