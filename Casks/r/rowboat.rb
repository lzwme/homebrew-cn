cask "rowboat" do
  arch arm: "arm64", intel: "x64"

  version "0.3.5"
  sha256 arm:   "0d5ef4ad1457f816c4edcaea833d3a7fdc7ed471d973662d5082e9ed4f859f9d",
         intel: "11df40573c6457728572d8a254bdeabd5a62a1db380d42d1d6961f6ba1a78df0"

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