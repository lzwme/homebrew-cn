cask "portfolioperformance" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.67.3"
  sha256 arm:   "d783c82172ca453aecfb61ccb3991ec2d85d10184007ba592e94d9e5735d9c4f",
         intel: "5190ada0e4ab7f6dcb352262d1837749aceb6e4b73fa36b4eb9f8ca95eda1eea"

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