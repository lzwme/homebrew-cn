cask "copilot-cli" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "1.0.40"
  sha256 arm:          "866c967d1f0404bbca678c1ef439043a06e5912f08650be82ea4c19595886ae3",
         intel:        "91b3ff64c5d4706da4a5d9aca019544fefc8d29685495ca69648a2e6b6a22e45",
         arm64_linux:  "3f13be3a2a20b46d12f0e0a1215021d565c2e14252327ebb71aca20ed30ac00b",
         x86_64_linux: "113945f763c0f7abc95f7a0405e429c5857aa0a8422b41300048b2df9906ccf6"

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