cask "luxury-yacht" do
  arch arm: "arm64", intel: "amd64"

  version "1.7.1"
  sha256 arm:   "ad1610082afaea3ef3998e0f3f6e65689aadc00227126ce8b81387064ddb7028",
         intel: "10eca23354471620de0723bdbc0775e6d46179923f77cd11598ffc7327c561cb"

  url "https://ghfast.top/https://github.com/luxury-yacht/app/releases/download/v#{version}/luxury-yacht-v#{version}-macos-#{arch}.dmg",
      verified: "github.com/luxury-yacht/app/"
  name "Luxury Yacht"
  desc "Desktop app for managing Kubernetes clusters"
  homepage "https://luxury-yacht.app/"

  depends_on :macos

  app "Luxury Yacht.app"

  zap trash: "~/Library/Application Support/luxury-yacht"
end