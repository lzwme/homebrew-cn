cask "portfolioperformance" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.66.2"
  sha256 arm:   "faf7c91646a1d55d56dc98c1813264f297d5dae83da543aae9bb6915ca4c4440",
         intel: "f1c8f0518f3f3a54872a6312b0a22f2cd25d3721855ff30efd22894b54e2e0ef"

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