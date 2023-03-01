cask "ultrastar-deluxe" do
  version "2020.4.0"
  sha256 "21c46ed7cc77fd4678b395fc9cc346c572cc5798df8479392968cb684ca2b5d9"

  url "https://ghproxy.com/https://github.com/UltraStar-Deluxe/USDX/releases/download/v2020.4.0/UltraStar.Deluxe-v2020.4.0.stable_macOS.dmg",
      verified: "github.com/UltraStar-Deluxe/USDX/"
  appcast "https://github.com/UltraStar-Deluxe/USDX/releases.atom"
  name "UltraStar Deluxe"
  desc "UltraStar Deluxe is an open source karaoke party game"
  homepage "https://usdx.eu/"

  app "UltraStarDeluxe.app"
end