cask "emdash" do
  arch arm: "arm64", intel: "x64"

  version "0.4.17"
  sha256 arm:   "e5909d5185a09b42e0931e41c52a16385605f3a756e858d769dba27a14bbbc1a",
         intel: "17d551bb55f3752dea7443eb1dc0121b0cd3e677497feb5abc811a86bc0f82c1"

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