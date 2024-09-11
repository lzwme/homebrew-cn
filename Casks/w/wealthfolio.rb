cask "wealthfolio" do
  arch arm: "aarch64", intel: "x64"

  version "1.0.11"
  sha256 arm:   "3416c8cd529317958c4562f798a1273afdc2d62b4ab7334a695112667b725646",
         intel: "01a6e1a10bc973e8e2a871ef92eb9ed0e62834a96a66d87eccc50c9fb57cc944"

  url "https:github.comafadilwealthfolioreleasesdownloadv#{version}Wealthfolio_#{version}_#{arch}.dmg",
      verified: "github.comafadilwealthfolio"
  name "Wealthfolio"
  desc "Investment portfolio tracker"
  homepage "https:wealthfolio.app"

  livecheck do
    url "https:wealthfolio.appreleasesdarwin#{arch}latest"
    strategy :json do |json|
      json["version"]
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Wealthfolio.app"

  zap trash: [
    "~LibraryApplication Supportcom.teymz.wealthfolio",
    "~LibraryCachescom.teymz.wealthfolio",
    "~LibraryWebKitcom.teymz.wealthfolio",
  ]
end