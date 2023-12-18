cask "ultrastar-deluxe" do
  version "2023.6.0"
  sha256 "a0d47271ae836fd2fccf6962ca127e1ad0313a6ea3f455ad336510e13a85ded0"

  url "https:github.comUltraStar-DeluxeUSDXreleasesdownloadv2023.6.0UltraStarDeluxe-v2023.6.0-0.dmg",
      verified: "github.comUltraStar-DeluxeUSDX"
  appcast "https:github.comUltraStar-DeluxeUSDXreleases.atom"
  name "UltraStar Deluxe"
  desc "UltraStar Deluxe is an open source karaoke party game"
  homepage "https:usdx.eu"

  app "UltraStarDeluxe.app"
end