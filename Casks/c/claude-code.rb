cask "claude-code" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.59"
  sha256 arm:          "ef70dae6ed08b5538f6d157a8c8591f72c262fb8e570c94711bad3ae4ee44afa",
         x86_64:       "b3b69beae466ac1b7659bf5710ec1d5e7b20c848418cc701019462e0923ff0e0",
         x86_64_linux: "7a4a653982b07e0a8157f8d3b2c2f8e442520ab07b2fa2e692ba054dbba210c9",
         arm64_linux:  "78b0ea5a64793149f550ad3ddcfcbc7147128a600243839f703fb5b6a2194859"

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