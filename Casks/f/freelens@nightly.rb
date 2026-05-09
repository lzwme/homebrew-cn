cask "freelens@nightly" do
  arch arm: "arm64", intel: "amd64"

  version "1.9.1-0-nightly-2026-05-08"
  sha256 arm:   "6f664fe1c3a3337288356ed77fa190a17be14e0dd6aab97b36744c5969959d1c",
         intel: "8dd97d9b4804e29450e38d769f03a65871de8862767fc6647bdd652abf7ff9b1"

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