cask "freelens@nightly" do
  arch arm: "arm64", intel: "amd64"

  version "1.8.2-0-nightly-2026-02-22"
  sha256 arm:   "85e2df1b0e28c28fc507efbea2e1ac2ddb8e7f93305ee797dc7c7e04305e0c5d",
         intel: "9b68a39a5f6c53e4d6a9184acb64ff6f386b9bb6c603a4cb02d109ef834a5abc"

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