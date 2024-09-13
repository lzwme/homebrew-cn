cask "wealthfolio" do
  arch arm: "aarch64", intel: "x64"

  version "1.0.13"
  sha256 arm:   "a88e13ffadb80ab593ca99aa2b07bbf92a11f7e31218267257b1751ee9d221e2",
         intel: "0c8e74560bf13c5b524e4eb177a9a29496de60d5f6d196306b3bd9dfa55f15c7"

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