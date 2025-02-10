cask "ultrastardeluxe" do
  arch arm: "ARM", intel: "x86"

  version "2025.2.1"
  sha256 arm:   "9b89eb8faa2b0eee900bc54865801ef6d7f2f2bd89ad2c86b03027a2ba72ac82",
         intel: "c8302f7ef213067966383b6b785d28af192504811f8f0d15d3caf399c29e51e3"

  url "https:github.comUltraStar-DeluxeUSDXreleasesdownloadv#{version}UltraStarDeluxe-mac-#{arch}-#{version}.dmg",
      verified: "github.comUltraStar-DeluxeUSDX"
  name "UltraStar Deluxe"
  desc "Karaoke game"
  homepage "https:usdx.eu"

  app "UltraStarDeluxe.app"

  zap trash: "~LibraryApplication SupportUltraStarDeluxe1.3"
end