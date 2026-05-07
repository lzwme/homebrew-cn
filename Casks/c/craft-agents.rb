cask "craft-agents" do
  arch arm: "arm64", intel: "x64"

  version "0.9.2"
  sha256 arm:   "5c27c8fff0546ad6d114929a2bec842c9764d245344ab98f5e11e61b56f7cab2",
         intel: "e01d6866db6f1f1113d890169ecb5ff464c8d2c55b03ad55299fc3583403c9a8"

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