cask "portfolioperformance" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.68.3"
  sha256 arm:   "4cca40ec9e5f4dc54c904ba0c5cf43b214376673f20877e2b1198b17cfbacb01",
         intel: "b0d3e3a434712ca849c7e2c2147b98009c6538f87aa9b1ead006667198321d9d"

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