cask "osaurus" do
  version "0.0.40"
  sha256 "e2975fb7e7e6abf825276e84b3f0d47e974e00368ff9f26e36c30e686f59ed96"

  url "https://ghfast.top/https://github.com/dinoki-ai/osaurus/releases/download/#{version}/Osaurus-#{version}.dmg",
      verified: "github.com/dinoki-ai/osaurus/"
  name "Osaurus"
  desc "LLM server built on MLX"
  homepage "https://dinoki.ai/osaurus"

  depends_on macos: ">= :sequoia"
  depends_on arch: :arm64

  app "osaurus.app"

  zap trash: [
    "~/Library/Application Support/com.dinoki.osaurus",
    "~/Library/Application Support/Osaurus",
    "~/Library/Caches/com.dinoki.osaurus",
    "~/Library/HTTPStorages/com.dinoki.osaurus",
    "~/Library/Preferences/ai.dinoki.osaurus.plist",
    "~/Library/Saved Application State/ai.dinoki.osaurus.savedState",
    "~/MLXModels",
  ]
end