cask "emdash" do
  arch arm: "arm64", intel: "x64"

  version "0.4.19"
  sha256 arm:   "5c3d92286aa2d52cf753150ca6bb3d5957f5fa860621e943cd296f7d0ca6d15c",
         intel: "ff633cfa7ceb7d285a4d434cd59eaa4a3741a7eb6e039f9b02f03ed64e697b81"

  url "https://ghfast.top/https://github.com/generalaction/emdash/releases/download/v#{version}/emdash-#{arch}.dmg",
      verified: "github.com/generalaction/emdash/"
  name "Emdash"
  desc "UI for running multiple coding agents in parallel"
  homepage "https://www.emdash.sh/"

  depends_on macos: ">= :big_sur"

  app "emdash.app"

  zap trash: [
    "/Library/Logs/emdash",
    "/Library/Saved Application State/com.emdash.savedState",
    "~/Library/Application Support/emdash",
    "~/Library/Preferences/com.emdash.plist",
  ]
end