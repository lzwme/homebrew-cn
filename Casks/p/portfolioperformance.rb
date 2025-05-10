cask "portfolioperformance" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.76.2"
  sha256 arm:   "14addb57938f22f14ce0b314a76fdec90613d0e8f4a1175638bd68df8112cb9d",
         intel: "d6bdc51f88c7e2b1bbcb68129c16b7abad0faebf05f64cad40ed3fde232a9473"

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