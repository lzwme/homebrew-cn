cask "claude-code" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.61"
  sha256 arm:          "3f5d3706746effb2f875e3db66682662ea3b5d7c196b5a0fad8fb37a6fc6cfdb",
         x86_64:       "d44816c633867d4ac83fbb24dceda33af587969d9af41e2282fb410d38a86df2",
         x86_64_linux: "b1c15907b3ee39b2f0b6cc6427672206dbc9e5a68c54448d3b0dc411776eb031",
         arm64_linux:  "c9f1dac058c6eb4530d12ccb89241363e730d4452a53277ecae76527c45c0c5e"

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