cask "claude-code" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.62"
  sha256 arm:          "94f813561519676a95135e3d3631cbc74a14883222af20def6d5040d193cd5e7",
         x86_64:       "4a9d619cde93101dd3279211cf1053db942f97d6a323cec1b570d52f43f1f3a9",
         x86_64_linux: "d6f0726cb8e94b7a30c243964529ba9135e642c40d2134ca09f5f845071471b4",
         arm64_linux:  "696c2f2a22a23375e9d7ee26af0aff417cd4a3a8cb704f24e4ba9c74a4c78d37"

  url "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/#{version}/#{os}-#{arch}/claude",
      verified: "storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/"
  name "Claude Code"
  desc "Terminal-based AI coding assistant"
  homepage "https://www.anthropic.com/claude-code"

  livecheck do
    url "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/latest"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

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