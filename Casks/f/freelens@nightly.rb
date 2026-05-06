cask "freelens@nightly" do
  arch arm: "arm64", intel: "amd64"

  version "1.9.0-0-nightly-2026-05-05"
  sha256 arm:   "f9da59ff32621fd24d3d953df3a92d7fe0f62146720ffa519afb040465c7ce21",
         intel: "4f0a6065224600572fe42de68d58657790353e74663024f24f7d211752078558"

  url "https://ghfast.top/https://github.com/freelensapp/freelens-nightly-builds/releases/download/v#{version}/Freelens-#{version}-macos-#{arch}.dmg",
      verified: "github.com/freelensapp/freelens-nightly-builds/"
  name "Freelens"
  desc "Kubernetes IDE"
  homepage "https://freelens.app/"

  conflicts_with cask: "freelens"
  depends_on macos: ">= :monterey"

  app "Freelens.app"

  zap trash: [
    "~/Library/Application Support/Freelens",
    "~/Library/Logs/Freelens",
  ]
end