cask "ultrastar-deluxe" do
  version "2023.5.0"
  sha256 "7f646ca8db28be8d4c938ef7d8a934b6c1e276db09855caa2c8ee2b2be84455b"

  url "https://ghproxy.com/https://github.com/UltraStar-Deluxe/USDX/releases/download/v2023.5.0/UltraStarDeluxe_v2023.5.0-0.dmg",
      verified: "github.com/UltraStar-Deluxe/USDX/"
  appcast "https://github.com/UltraStar-Deluxe/USDX/releases.atom"
  name "UltraStar Deluxe"
  desc "UltraStar Deluxe is an open source karaoke party game"
  homepage "https://usdx.eu/"

  app "UltraStarDeluxe.app"
end