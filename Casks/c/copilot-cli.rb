cask "copilot-cli" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "1.0.39"
  sha256 arm:          "2ab5a564165894103780698a17af9b6016ef5392d6699b0804451f543b0cac54",
         intel:        "cbb1f91a8bb7dd7028d2087587715ac4126cab5154396cf4e398f2b759d3a8ef",
         arm64_linux:  "d128ee5cf7d2e7ec6c87511cfcb11f3e072bb679618ca9a465da30f087bfde86",
         x86_64_linux: "66ddea6612a5621adc734d6ea2ce150cb85682a3e32f08bf90695fc29374616a"

  url "https://ghfast.top/https://github.com/github/copilot-cli/releases/download/v#{version}/copilot-#{os}-#{arch}.tar.gz"
  name "GitHub Copilot CLI"
  desc "Brings the power of Copilot coding agent directly to your terminal"
  homepage "https://docs.github.com/en/copilot/concepts/agents/about-copilot-cli"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  conflicts_with cask: "copilot-cli@prerelease"
  depends_on macos: ">= :ventura"

  binary "copilot"

  zap trash: "~/.copilot"
end