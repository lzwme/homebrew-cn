cask "luxury-yacht" do
  arch arm: "arm64", intel: "amd64"

  version "1.3.11"
  sha256 arm:   "f7a51b7d77ea2ebd7071a74a5b6369c7dc22a946c2c7ba1f62521db07b401192",
         intel: "177a330e3d0bb0daf6f64c2f5bb5cc2e7e770ccab57491c8b7c1ab2921278044"

  url "https://ghfast.top/https://github.com/luxury-yacht/app/releases/download/v#{version}/luxury-yacht-v#{version}-macos-#{arch}.dmg",
      verified: "github.com/luxury-yacht/app/"
  name "Luxury Yacht"
  desc "Desktop app for managing Kubernetes clusters"
  homepage "https://luxury-yacht.app/"

  app "Luxury Yacht.app"

  zap trash: "~/Library/Application Support/luxury-yacht"
end