cask "rowboat" do
  arch arm: "arm64", intel: "x64"

  version "0.3.8"
  sha256 arm:   "6cec866e08ac47e29c9483f97c71a7af25ed6f8a11f071a1fbc4fe2be2c2dc54",
         intel: "1f75f15649e9196f28b3b25e634cd6a386dd78f5129413f5a48eca6c161bb80e"

  url "https://ghfast.top/https://github.com/rowboatlabs/rowboat/releases/download/v#{version}/Rowboat-darwin-#{arch}-#{version}.zip",
      verified: "github.com/rowboatlabs/rowboat/"
  name "Rowboat"
  desc "Open-source AI coworker, with memory"
  homepage "https://www.rowboatlabs.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :monterey"

  app "rowboat.app"

  zap trash: [
    "~/.rowboat",
    "~/Library/Application Support/Rowboat",
  ]
end