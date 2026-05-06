cask "craft-agents" do
  arch arm: "arm64", intel: "x64"

  version "0.9.1"
  sha256 arm:   "2ca7212a765ab94a135c5d34de6b9bf85c74db5ef64f226a71ae999d615e2b29",
         intel: "ed5a52b93d92b119be927f760e3f884d44541c1f04b3082c51b2ee80fb1918ad"

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