cask "claude-devtools" do
  arch arm: "-arm64", intel: "-x64"

  version "0.4.15"
  sha256 arm:   "a50b00867921bdc9795b0f0cfbdd624fe2ff00262e4250e07aac36afd8aed7bb",
         intel: "4396c731119765c3d0fa4758de92bd2caf8ea6bc58bd2adfaf3e0829781c068a"

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