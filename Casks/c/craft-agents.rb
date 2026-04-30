cask "craft-agents" do
  arch arm: "arm64", intel: "x64"

  version "0.8.13"
  sha256 arm:   "7a419ff386fa2b1291f412c7e7c616630994b796b80ff202d934e51bf8e35d16",
         intel: "039dd60934ed85ec1fe5a88ef1a29786dcd3eda427735d712ca141285a500473"

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