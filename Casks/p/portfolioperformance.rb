cask "portfolioperformance" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.67.2"
  sha256 arm:   "699f383d977eca6c135f90524c8c4063eb2bac90a671d5e260361d60f5a22407",
         intel: "248be819651e115da6aab6a1fb19d40f0e4867f15b87ae665e61bc90508b31e1"

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