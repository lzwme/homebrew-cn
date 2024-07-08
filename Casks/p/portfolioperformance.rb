cask "portfolioperformance" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.69.1"
  sha256 arm:   "8b4afa8102e5f97f86a597d7b7636b3429d2e1db7626869afef92676d1540fb7",
         intel: "a340d3214351879ed5e722696d120f9ba496c0c68e7a8538e78291602d5b54bd"

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