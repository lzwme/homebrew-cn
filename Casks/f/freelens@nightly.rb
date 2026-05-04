cask "freelens@nightly" do
  arch arm: "arm64", intel: "amd64"

  version "1.9.0-0-nightly-2026-05-03"
  sha256 arm:   "d3c7e3853d746b5e4ea0ea53612469cac13b6e275256d386e8c5e12c1535f515",
         intel: "9b15a89b4cab623838fe26398a1fbb579ca2104e6d128b672e778dd27d8e45d7"

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