cask "wealthfolio" do
  arch arm: "aarch64", intel: "x64"

  version "1.0.19"
  sha256 arm:   "7ff32372c4abaad3e09d7503b40cc425a52c7fda6dc0e95216d889748054450b",
         intel: "10b3a19c30adf9d996b22301e9ceb72e0b614cf0ac4675750c19ded7d25e15dd"

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