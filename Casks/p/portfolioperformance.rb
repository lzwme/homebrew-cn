cask "portfolioperformance" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.77.2"
  sha256 arm:   "8c726666058fb18d388d995410f42a9e0e55c0477072f67c78de08971a8e3168",
         intel: "d9782975d82c287db15d6aac2c05545015d1bfba5640218e11b92c0426934215"

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