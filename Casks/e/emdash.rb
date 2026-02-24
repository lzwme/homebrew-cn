cask "emdash" do
  arch arm: "arm64", intel: "x64"

  version "0.4.16"
  sha256 arm:   "df62b29dbe3fcd5dec9e9494b2898fca67ff865cadb98ae447dfeae9bc479cb3",
         intel: "1a95daf57c3074ca99f8b4c65ae811a01f9789fffdafc80f00d38cee60e1cbff"

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