cask "copilot-cli" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "0.0.418"
  sha256 arm:          "1143123b0280a8facf04c57d2e0ad80ac99848c1c53962f1169cb343bb67ccc8",
         intel:        "0b4d2227be2c0303529c3c95bf7348c25e9bcc3e2d9d0de10fec699751af0815",
         arm64_linux:  "c87a925dca46f40098108a6525ba40441afd3cd51f3bcf695511688cb1d158c7",
         x86_64_linux: "c1f6f7614b9ccedcaba5ecafc4dbdf868a4c3dc0ae8e98746fd98d5a1f611848"

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