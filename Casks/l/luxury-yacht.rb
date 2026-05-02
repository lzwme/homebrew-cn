cask "luxury-yacht" do
  arch arm: "arm64", intel: "amd64"

  version "1.7.2"
  sha256 arm:   "62140bd17ece71dbdb48abbc6966ee0d97d4637a95a7b6d141b2fa93477a20b2",
         intel: "a1e37d9bc83021545fb98722888b251ce8845de6b662409016d073aae0f8003c"

  url "https://ghfast.top/https://github.com/luxury-yacht/app/releases/download/v#{version}/luxury-yacht-v#{version}-macos-#{arch}.dmg",
      verified: "github.com/luxury-yacht/app/"
  name "Luxury Yacht"
  desc "Desktop app for managing Kubernetes clusters"
  homepage "https://luxury-yacht.app/"

  depends_on :macos

  app "Luxury Yacht.app"

  zap trash: "~/Library/Application Support/luxury-yacht"
end