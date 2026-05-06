cask "luxury-yacht" do
  arch arm: "arm64", intel: "amd64"

  version "1.8.3"
  sha256 arm:   "c83f1c25db3c2d295678e277cc198b1f80970eda0bee9529cad1b0895f0b6341",
         intel: "906dfbf5dfec44d721b382dc40073fc4b842b343fc5fa276cffbe3209ea91ed4"

  url "https://ghfast.top/https://github.com/luxury-yacht/app/releases/download/v#{version}/luxury-yacht-v#{version}-macos-#{arch}.dmg",
      verified: "github.com/luxury-yacht/app/"
  name "Luxury Yacht"
  desc "Desktop app for managing Kubernetes clusters"
  homepage "https://luxury-yacht.app/"

  depends_on :macos

  app "Luxury Yacht.app"

  zap trash: "~/Library/Application Support/luxury-yacht"
end