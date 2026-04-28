cask "hotovo-aider-desk" do
  arch arm: "arm64", intel: "x64"

  version "0.63.0"
  sha256 arm:   "1042fce0c513c002f0a8f36fb92a473bba74c97decf108d355b49797b48b603a",
         intel: "7c6f64d69cc95acc0e055926ce0a9626d79c0cce871be8247d8165bcf0914cb9"

  url "https://ghfast.top/https://github.com/hotovo/aider-desk/releases/download/v#{version}/aider-desk-#{version}-macos-#{arch}.dmg"
  name "AiderDesk"
  desc "Desktop GUI for Aider AI pair programming"
  homepage "https://github.com/hotovo/aider-desk"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "aider-desk.app"

  zap trash: [
    "~/Library/Application Support/aider-desk",
    "~/Library/Logs/aider-desk",
    "~/Library/Preferences/com.hotovo.aider-desk.plist",
    "~/Library/Saved Application State/com.hotovo.aider-desk.savedState",
  ]
end