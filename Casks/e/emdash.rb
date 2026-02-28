cask "emdash" do
  arch arm: "arm64", intel: "x64"

  version "0.4.20"
  sha256 arm:   "9bdd10e4de5067e77f2c85d24d52c7ab2093f6cea31c9ae6bb3f44b7f8cd73c2",
         intel: "7b2d5774700299524fd617cd73e09f20b16f776e5e579c233032c28f90e4f780"

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