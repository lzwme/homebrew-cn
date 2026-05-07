cask "freelens@nightly" do
  arch arm: "arm64", intel: "amd64"

  version "1.9.1-0-nightly-2026-05-06"
  sha256 arm:   "bd5fc3e2e331faa1ab15760d1befc46344d46046937f6fa4cc69224e80abc58e",
         intel: "b5cec1ee21db88950bc622acdcd5cb2e5013f6ec97f585f643633240ae36410b"

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