cask "freelens@nightly" do
  arch arm: "arm64", intel: "amd64"

  version "1.9.0-0-nightly-2026-05-02"
  sha256 arm:   "b2dac454fdd670becadd03946cd04241c23b4bba80445684327badb847add0ad",
         intel: "72be02ffbcc1961571dc707850e22c15e9bce5561f1387e865d3131a872424be"

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