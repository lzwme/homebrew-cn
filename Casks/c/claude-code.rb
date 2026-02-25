cask "claude-code" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.53"
  sha256 arm:          "1b6713b88d8b93fc9d268ffec3b27db270c96f742df82b4536e2e4f94efb1f52",
         x86_64:       "256f91562094c9af0271824ec65859719fb72636e8b93b8b5ad374eee6d135ab",
         x86_64_linux: "debf286f2a5e974a50f102a034a2dfb5df8cf4ac54f7f4136260b5f900385757",
         arm64_linux:  "fba4d70283aea66df7d50fd6cf33cec0fbcb0bf7959abe284f8a5a5672ed5e33"

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