cask "wealthfolio" do
  arch arm: "aarch64", intel: "x64"

  version "1.0.16"
  sha256 arm:   "3e5c98b196383dd92b2a27982fb891873f4270ad157c026c349822309d5294b0",
         intel: "cf14587b0b08fbe2f8412c0b229bb9c13e1fc09d26a0cf68e8bbdc0b5a2d7b06"

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