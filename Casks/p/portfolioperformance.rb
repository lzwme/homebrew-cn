cask "portfolioperformance" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.74.2"
  sha256 arm:   "2f7b9b275f5132d1e5216558759b9fa0155442f8e291aea579a91bf4a8c35f19",
         intel: "0a151d8dba8f902f5356494f01c7e218261c1c6e1da507dd1694041cadfcccf8"

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