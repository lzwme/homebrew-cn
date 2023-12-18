cask "ultrastardeluxe" do
  version "2023.12.0"
  sha256 "8cdf126826d708f0d658b5e2d47bbf87bc72fd0f881e1393e12b5130516ca164"

  url "https:github.comUltraStar-DeluxeUSDXreleasesdownloadv#{version}UltraStarDeluxe-v#{version}.dmg",
      verified: "github.comUltraStar-DeluxeUSDX"
  name "UltraStar Deluxe"
  desc "Karaoke game"
  homepage "https:usdx.eu"

  app "UltraStarDeluxe.app"

  zap trash: "~LibraryApplication SupportUltraStarDeluxe1.3"
end