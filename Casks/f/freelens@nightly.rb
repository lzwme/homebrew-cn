cask "freelens@nightly" do
  arch arm: "arm64", intel: "amd64"

  version "1.9.1-0-nightly-2026-05-07"
  sha256 arm:   "484fa958281b46456a998ade2b83a2422b3b14639e70eee9c2934b682f426ead",
         intel: "ce5615fe717a0920e5ab5e5751623cbef81ab3203dd189008f2a3820d61c77a8"

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