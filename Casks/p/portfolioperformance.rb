cask "portfolioperformance" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.75.1"
  sha256 arm:   "7de689c6d55bfd462d3a9a79e37a584e7af494e2ae0787c60bd1382674b6aa01",
         intel: "b479a89d88ce8501af7f02c7336a4b851bc93357b570ce6ea597e53aea2f3064"

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