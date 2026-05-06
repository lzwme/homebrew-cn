cask "copilot-cli" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "1.0.41"
  sha256 arm:          "458448db454dc28250c2b83c08e2881d871b1c9973669ac564ff81ad76dff0ba",
         intel:        "0c5deba04f9fd3644ffc7016069d966b1288b9f2734706bad532f0dc102add44",
         arm64_linux:  "7d5b77ce0cf8b1eb1e58c507216199fc51cfa4fb987bd6ed46cc32483eb7fa57",
         x86_64_linux: "eead744dbc46591110cede7f078cdca0708ecc673e43fc7572e01d292bb5ddfb"

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