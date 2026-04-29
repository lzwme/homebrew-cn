cask "claude-code@latest" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.122"
  sha256 arm:          "4b01075bd923084fe56124bfb647f5eca98c2b1fa34cb039d2e75ccc84af4b86",
         x86_64:       "8c56cd72093c4b0002c7ec04ad69c0f0d04f0042c9fe399c194639f2d350934d",
         x86_64_linux: "5525f482dd1fa6e3fe5fa48ae7a82dd9e2db7293af165a56c95fcc7899cd8468",
         arm64_linux:  "ec608f447cf8d8a323e174a7b95f664d4835a77562c31f8562fa35b01e326d07"

  url "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/#{version}/#{os}-#{arch}/claude",
      verified: "storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/"
  name "Claude Code"
  desc "Terminal-based AI coding assistant"
  homepage "https://www.anthropic.com/claude-code"

  livecheck do
    url "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/latest"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  conflicts_with cask: "claude-code"

  binary "claude"

  zap trash: [
        "~/.cache/claude",
        "~/.claude.json*",
        "~/.config/claude",
        "~/.local/bin/claude",
        "~/.local/share/claude",
        "~/.local/state/claude",
        "~/Library/Caches/claude-cli-nodejs",
      ],
      rmdir: "~/.claude"
end