cask "wealthfolio" do
  arch arm: "aarch64", intel: "x64"

  version "1.0.10"
  sha256 arm:   "3a7fe2f08e80288d1cf3a8a12e91b6b4114916cc632ff59fd24d0d2166e7f34b",
         intel: "c31e4e6e407a3d82abe66fb8385c00b50961e070a2d5ae88c00bba1b6f115b8d"

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