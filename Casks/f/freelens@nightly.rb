cask "freelens@nightly" do
  arch arm: "arm64", intel: "amd64"

  version "1.9.0-0-nightly-2026-05-04"
  sha256 arm:   "fdb3f6b6e7e6c0c6cb92458952f324f2e03fc1bf71a0c776df9e0bd620282075",
         intel: "09c509f0a5242ef300d73dc58184c7d12ecb4f6f25c84b6c2c3d82a30ca7fd3d"

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