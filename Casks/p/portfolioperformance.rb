cask "portfolioperformance" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.77.3"
  sha256 arm:   "eddc2cf973130ee5c495ab374861d5a5c32fb83b76cfb6ec3c756954e0c2f0c8",
         intel: "18f51a2937f1021c784a43be9e1a5d66c1bd57a8fd5fddb3023543c25b86d2f7"

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