cask "osaurus" do
  version "0.2.1"
  sha256 "ff24ee6c18b77efa902f6283e9453eff786a8e6726253ac124201be54041a182"

  url "https://ghfast.top/https://github.com/dinoki-ai/osaurus/releases/download/#{version}/Osaurus-#{version}.dmg",
      verified: "github.com/dinoki-ai/osaurus/"
  name "Osaurus"
  desc "LLM server built on MLX"
  homepage "https://osaurus.ai/"

  depends_on macos: ">= :sequoia"
  depends_on arch: :arm64

  app "osaurus.app"
  binary "#{appdir}/osaurus.app/Contents/MacOS/osaurus"

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