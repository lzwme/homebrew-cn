cask "wealthfolio" do
  arch arm: "aarch64", intel: "x64"

  version "3.0.0"
  sha256 arm:   "6f6760ad45fc98c20a7870fae1169fcbb816f96c9f3153eeaf1a75595711e2f5",
         intel: "358c701fa4132da116cffa7e40dd4c5a4b06db5af8c051a5189ad93d5e46da24"

  url "https://ghfast.top/https://github.com/afadil/wealthfolio/releases/download/v#{version}/Wealthfolio_#{version}_#{arch}.dmg",
      verified: "github.com/afadil/wealthfolio/"
  name "Wealthfolio"
  desc "Investment portfolio tracker"
  homepage "https://wealthfolio.app/"

  livecheck do
    url "https://wealthfolio.app/releases/darwin/#{arch}/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  auto_updates true

  app "Wealthfolio.app"

  zap trash: [
    "~/Library/Application Support/com.teymz.wealthfolio",
    "~/Library/Caches/com.teymz.wealthfolio",
    "~/Library/WebKit/com.teymz.wealthfolio",
  ]
end