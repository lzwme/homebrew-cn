cask "ultrastar-deluxe" do
  version "2024.3.0"
  sha256 "73a2ca351bbdf74192d961fc517be9e2f2b1c3e0ba8f84d45bd980e5253ba0ff"

  url "https:github.comUltraStar-DeluxeUSDXreleasesdownloadv#{version}UltraStarDeluxe-v#{version}.dmg",
      verified: "github.comUltraStar-DeluxeUSDX"
  name "UltraStar Deluxe"
  desc "Open Source Karaoke Party Game"
  homepage "https:usdx.eu"

  livecheck do
    url :stable
  end

  app "UltraStarDeluxe.app"
end