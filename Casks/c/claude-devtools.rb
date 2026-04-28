cask "claude-devtools" do
  arch arm: "-arm64"

  version "0.4.13"
  sha256 arm:   "61a5ed9409bfc7bd48340936a154fdc8088e8dbc1772b18736d5dc35505d009f",
         intel: "8dbad9db18e38e22223feb1995a1d5fdb66e892e93675b6a6adb14d7ef1f04d8"

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