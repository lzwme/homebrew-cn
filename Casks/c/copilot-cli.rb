cask "copilot-cli" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "0.0.420"
  sha256 arm:          "8216312d266329ea0b1440cc2e685c66b6a26977cfa3d02b0388d6051f3fb6ab",
         intel:        "cd47e1d5287f724be05acfd8564a4628bf6f622dde8156f8b269e1641409989b",
         arm64_linux:  "60afebcf47644db1cedd4bbe2be9fc18e6ffb4bc394f570a7896b7a8fd889f63",
         x86_64_linux: "344f89ee1e619c9ffcb072381b7e53c2f305053008b55584dc5846d003c167b9"

  url "https://ghfast.top/https://github.com/github/copilot-cli/releases/download/v#{version}/copilot-#{os}-#{arch}.tar.gz"
  name "GitHub Copilot CLI"
  desc "Brings the power of Copilot coding agent directly to your terminal"
  homepage "https://docs.github.com/en/copilot/concepts/agents/about-copilot-cli"

  livecheck do
    url :url
    strategy :github_latest
  end

  conflicts_with cask: "copilot-cli@prerelease"
  depends_on macos: ">= :ventura"

  binary "copilot"

  zap trash: "~/.copilot"
end