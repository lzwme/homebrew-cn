cask "craft-agents" do
  arch arm: "arm64", intel: "x64"

  version "0.9.0"
  sha256 arm:   "51917b54f236353d657dfb5215d10a8fd755deb86d0da6212a941e5c99e7d445",
         intel: "c347dbe7dea206275d64908d3608ab8e024265784d178d15c08ec8adca638f83"

  url "https://ghfast.top/https://github.com/lukilabs/craft-agents-oss/releases/download/v#{version}/Craft-Agents-#{version}-mac-#{arch}.dmg",
      verified: "github.com/lukilabs/craft-agents-oss/"
  name "Craft Agents"
  desc "AI assistant for connecting and working across data sources"
  homepage "https://agents.craft.do/"

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Craft Agents.app"

  zap trash: [
    "~/Library/Application Support/Craft Agents",
    "~/Library/Caches/com.lukilabs.craft-agent",
    "~/Library/HTTPStorages/com.lukilabs.craft-agent",
    "~/Library/Preferences/com.lukilabs.craft-agent.plist",
    "~/Library/Saved Application State/com.lukilabs.craft-agent.savedState",
  ]
end