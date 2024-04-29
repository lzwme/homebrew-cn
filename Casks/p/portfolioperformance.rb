cask "portfolioperformance" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.68.4"
  sha256 arm:   "cf9bce89988ce9f36626a0ac35553a9b27ff2af4f8bd59b41cb4bd1cf9b68cad",
         intel: "e43a37f5c70803e0d91989d110914ead98164f9f2587fc6cad547d19fc9513f2"

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