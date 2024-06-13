cask "portfolioperformance" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.69.0"
  sha256 arm:   "cf78650354a47396dbd96ea3bb2a47fcc99f53addb5210028e79c33894e58553",
         intel: "0fd6b1b08e3e64989262b27e95979d15a0c508461886884522dd020b16168e76"

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