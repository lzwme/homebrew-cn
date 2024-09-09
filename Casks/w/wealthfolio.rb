cask "wealthfolio" do
  arch arm: "aarch64", intel: "x64"

  version "1.0.8"
  sha256 arm:   "f0d67a5915d13cdc0d326310d81b5d3dfa4ee07def56616feb7a92e8a0c08f44",
         intel: "f12fd6fd99752ca7ad4aacc16e5f937ffc2b598a8731a56f7fdd820b72eacfb4"

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