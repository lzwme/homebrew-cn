cask "freelens@nightly" do
  arch arm: "arm64", intel: "amd64"

  version "1.8.2-0-nightly-2026-02-27"
  sha256 arm:   "db4740d3638a9ea506fed277fc64ee18a1e382eefa1c71a2dca23a1902424207",
         intel: "ecb9a24be9efd44edec27fd8fc951f610d0a4ac20b4d7d0698d6bd5c606bdfe0"

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