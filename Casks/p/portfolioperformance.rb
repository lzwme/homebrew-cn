cask "portfolioperformance" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.75.0"
  sha256 arm:   "658fdc67c1c55a823fb79a9049631716f586f85d487ac95f66389e1c75655d2b",
         intel: "5353f331b0c2332889b6fbceb12ac136bd74b6b259d70f7d1a39e8efd8ad9fa4"

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