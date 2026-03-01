cask "luxury-yacht" do
  arch arm: "arm64", intel: "amd64"

  version "1.3.12"
  sha256 arm:   "e6e8bd18668d14f770564293ca274da37d284cf5ed11615155b99b5d70cc2453",
         intel: "7820983255bceda350fea9ad1518a03d5558749f5a1e9ac8827827e3069e43e1"

  url "https://ghfast.top/https://github.com/luxury-yacht/app/releases/download/v#{version}/luxury-yacht-v#{version}-macos-#{arch}.dmg",
      verified: "github.com/luxury-yacht/app/"
  name "Luxury Yacht"
  desc "Desktop app for managing Kubernetes clusters"
  homepage "https://luxury-yacht.app/"

  app "Luxury Yacht.app"

  zap trash: "~/Library/Application Support/luxury-yacht"
end