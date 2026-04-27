cask "luxury-yacht" do
  arch arm: "arm64", intel: "amd64"

  version "1.7.0"
  sha256 arm:   "5e9f2ec16f24e703966787e7e0b139360a7b33d4f0e5dfa65e7ad55050550d09",
         intel: "163249e940f9903932b07526e68a934e4c94a563a837136b1da4b5225aecee87"

  url "https://ghfast.top/https://github.com/luxury-yacht/app/releases/download/v#{version}/luxury-yacht-v#{version}-macos-#{arch}.dmg",
      verified: "github.com/luxury-yacht/app/"
  name "Luxury Yacht"
  desc "Desktop app for managing Kubernetes clusters"
  homepage "https://luxury-yacht.app/"

  depends_on :macos

  app "Luxury Yacht.app"

  zap trash: "~/Library/Application Support/luxury-yacht"
end