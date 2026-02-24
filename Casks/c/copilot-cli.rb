cask "copilot-cli" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "0.0.415"
  sha256 arm:          "fee662566acc6793b1e959d4b3b1f0484fdd151c0c016451857cc2074856d232",
         intel:        "8dd7d2d4f927a81c708bcd78115404b86c7dea1b4c485e0e11361a0a55209e72",
         arm64_linux:  "b88926d243ce872c4443894107b1be6b87d09f3e6fec0332b0032c5aa62ba767",
         x86_64_linux: "fa013b719dc2f0a6b9a071aef5de85f5d5f53264415f4eb3a3e5cd3eac321a4a"

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