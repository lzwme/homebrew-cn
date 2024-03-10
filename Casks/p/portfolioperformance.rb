cask "portfolioperformance" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.68.1"
  sha256 arm:   "b40d02855d5d7de37d530d3333fbf9c34a11f5e8c8c3bdf1b492348165461412",
         intel: "2724d05cf49ad466a777b3e3773ec49d7b803809f968e437b89bc8cc451d409e"

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