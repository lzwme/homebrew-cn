cask "portfolioperformance" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.71.2"
  sha256 arm:   "96968cf307f1d58080b92f46c9b27d44f41dbbf4c01480f6b0b417b04398bce0",
         intel: "668be2400cc410c37565ad75db047c6929dc28437d25dc7b1778e4c9df128ed1"

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