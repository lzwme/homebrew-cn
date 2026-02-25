cask "copilot-cli" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "0.0.417"
  sha256 arm:          "a6240bd278d1b047e298eb0476b4fa29a4a0145a34c410698eea93091f6af3f8",
         intel:        "dd23275dbf0ad5413c06493d0b23793ef2b73ece97538c4c9e71002867bf50ed",
         arm64_linux:  "fd893155ae9ee501b11f9e96fdd98e9bcea9c3b0948763055dbac4d8b23714bd",
         x86_64_linux: "1d8d05589b2f31a0084641852bcd5cb1ef5a333725931407b3237f84be130f18"

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