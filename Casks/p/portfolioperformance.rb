cask "portfolioperformance" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.74.1"
  sha256 arm:   "8972a7c8148e8613bb32103f692eb2ec49521827d0965a0fcf46217fbf079e10",
         intel: "cda6ae5d7e01620c41ccf74e7f08c351c2405cbad1370f9efa1dcb258d575548"

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