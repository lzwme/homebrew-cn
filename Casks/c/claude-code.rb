cask "claude-code" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.63"
  sha256 arm:          "2e8667322e0bd104087df2a8857f176acc75d7091aa02828825dfeb4a5708531",
         x86_64:       "07842d6521f59bc68979d833ef33cbc1b985b9f5e09fa8975efe039989666aa9",
         x86_64_linux: "734447e461bb92f0ffd5f683bb6216c35a3c16e8dd84be8d150b43605d39b0d1",
         arm64_linux:  "1fec8c8369606b4a6c00af963354b7d48aee793ed5db378fe4cf280149f3190a"

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