cask "claude-devtools" do
  arch arm: "-arm64"

  version "0.4.6"
  sha256 arm:   "fe3b2e5e8e3d5db0512879f746448651a0af38fb37456e1b02382ab6454dad6a",
         intel: "8f53e2d913331e692d7c71372c6c82224d4cce3238b9005bec375d6812e1ec7e"

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