cask "portfolioperformance" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.76.3"
  sha256 arm:   "186ea1e17117d479623d5a11d71529a6212f03a59f29f3cd1e4bc55d4d94f680",
         intel: "37d046e7ba0276bf17092ff1a4f8129e69b3ffa4e4a4209b84b3c4ca6c0829bb"

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