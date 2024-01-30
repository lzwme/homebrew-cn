cask "leapp" do
  arch arm: "-arm64"

  version "0.24.4"
  sha256 arm:   "868bd7a168b613289f0ff9aab5afd253a4be6409e5671a7da621788dde3f3e4d",
         intel: "0ac4901fda14c7f624e6732164576bdb16bc524431de8b659f144a6a760d7e7c"

  url "https://asset.noovolari.com/#{version}/Leapp-#{version}#{arch}.dmg",
      verified: "asset.noovolari.com/"
  name "Leapp"
  desc "Cloud credentials manager"
  homepage "https://www.leapp.cloud/"

  livecheck do
    url "https://asset.noovolari.com/latest/latest-mac.yml"
    strategy :electron_builder
  end

  app "Leapp.app"

  zap trash: [
    "~/.Leapp",
    "~/Library/Application Support/Leapp",
    "~/Library/Logs/Leapp",
    "~/Library/Preferences/com.leapp.app.plist",
    "~/Library/Saved Application State/com.leapp.app.savedState",
  ]
end