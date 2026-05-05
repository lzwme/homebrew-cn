cask "luxury-yacht" do
  arch arm: "arm64", intel: "amd64"

  version "1.8.0"
  sha256 arm:   "fe8f3526d4e2a0653cca8298ff812f4d580609cf359423956ae1346d662a27e9",
         intel: "0a787dec0bbc62e8c35e462afd7a6c2bb527e74d4dd2375745da713c449428b4"

  url "https://ghfast.top/https://github.com/luxury-yacht/app/releases/download/v#{version}/luxury-yacht-v#{version}-macos-#{arch}.dmg",
      verified: "github.com/luxury-yacht/app/"
  name "Luxury Yacht"
  desc "Desktop app for managing Kubernetes clusters"
  homepage "https://luxury-yacht.app/"

  depends_on :macos

  app "Luxury Yacht.app"

  zap trash: "~/Library/Application Support/luxury-yacht"
end