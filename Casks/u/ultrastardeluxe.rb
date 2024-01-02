cask "ultrastardeluxe" do
  version "2024.1.0"
  sha256 "dfa1d535d0b19850e8d4ae0130881c99c9684da4b950cb3bdfbbc885bf021ae4"

  url "https:github.comUltraStar-DeluxeUSDXreleasesdownloadv#{version}UltraStarDeluxe-v#{version}.dmg",
      verified: "github.comUltraStar-DeluxeUSDX"
  name "UltraStar Deluxe"
  desc "Karaoke game"
  homepage "https:usdx.eu"

  app "UltraStarDeluxe.app"

  zap trash: "~LibraryApplication SupportUltraStarDeluxe1.3"
end