cask "portfolioperformance" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.74.0"
  sha256 arm:   "c9d55a156d22e6e173b7f27718806736306282d6c87ead7155dcc3ec33f6a524",
         intel: "d040249c8dddbd459e59f42af376f84f36b2f108487099d2fec018cb52e3a2e9"

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