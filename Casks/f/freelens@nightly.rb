cask "freelens@nightly" do
  arch arm: "arm64", intel: "amd64"

  version "1.9.0-0-nightly-2026-05-01"
  sha256 arm:   "49b6ba5711e488f1299529be3adfe80c0bf97ebd4efbb90d9c5af14af8c4452e",
         intel: "fd312a649cb188b830b680e4117be3efc0b2ab9546d41276502ecfbc63654966"

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