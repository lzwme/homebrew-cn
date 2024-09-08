cask "wealthfolio" do
  arch arm: "aarch64", intel: "x64"

  version "1.0.6"
  sha256 arm:   "485f2339e4bb61ee89ca835c0aeb93ed9e43928244c9d16a5024c364e0156cf3",
         intel: "fc3ba701d3c47c313b28f2710409a218ad9b9cefdbbda1d5d556a4ebb9dcf617"

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