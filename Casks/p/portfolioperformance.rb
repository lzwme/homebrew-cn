cask "portfolioperformance" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.67.0"
  sha256 arm:   "03db89bd0d016c903946018d8ecaa76b6338cb7aaa4856fc7a16d44069d99f18",
         intel: "82afabb12e0d5e3dce3c2b76f0211a1ddfdf1ee3edb451fcfeba614ad024ef3d"

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