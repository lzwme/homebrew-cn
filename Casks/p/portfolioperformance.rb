cask "portfolioperformance" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.76.1"
  sha256 arm:   "06a56084d2d84b25648d2f149228273bf35a4b652932dc2ce34f9f51a1ac9bea",
         intel: "2899ae535f1d3902dcb015f2c657944988fb8ac207c4544a6f0b3d00f118b3e2"

  url "https:github.combuchenportfolioreleasesdownload#{version}PortfolioPerformance-#{version}-#{arch}.dmg",
      verified: "github.combuchenportfolio"
  name "Portfolio Performance"
  desc "Calculate the overall performance of an investment portfolio"
  homepage "https:www.portfolio-performance.infoen"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app "PortfolioPerformance.app"

  zap trash: [
    "~LibraryApplication Supportname.abuchen.portfolio.product",
    "~LibraryCachesname.abuchen.portfolio.distro.product",
    "~LibraryPreferencesname.abuchen.portfolio.distro.product.plist",
  ]
end