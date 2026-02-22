cask "claude-devtools" do
  arch arm: "-arm64"

  version "0.4.5"
  sha256 arm:   "22a54f5c655e63450a0f4f2e1fbe4c06a879016a5fa02816031982e0fb22d0da",
         intel: "c8606de19c3e096c507130a31793d089223498c2fe2f44565fa398a7d2b7a73c"

  url "https://ghfast.top/https://github.com/matt1398/claude-devtools/releases/download/v#{version}/claude-devtools-#{version}#{arch}.dmg"
  name "Claude DevTools"
  desc "Visualise and analyse Claude Code session executions"
  homepage "https://github.com/matt1398/claude-devtools"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "claude-devtools.app"

  zap trash: [
    "~/Library/Application Support/claude-devtools",
    "~/Library/Caches/com.claudecode.context",
    "~/Library/Preferences/com.claudecode.context.plist",
  ]
end