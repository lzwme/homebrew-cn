cask "copilot-language-server" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "1.482.0"
  sha256 arm:          "164620634c263a22f4f59f97594e3ffd56db6384a963bb4d43e864f1da7a4e2e",
         intel:        "250ff004454c89dd0c36ac1962b673daceef28de82aef785f316b0414c748281",
         arm64_linux:  "fad3060419874166e0494494067bb91d62cfc61cbc9f9893e7c06c30419b3b7f",
         x86_64_linux: "dd6eb1e607ff6c0576e2660664d8e4b21df7026d2ae83fe0f0dbb3a53e17e3ab"

  url "https://ghfast.top/https://github.com/github/copilot-language-server-release/releases/download/#{version}/copilot-language-server-#{os}-#{arch}-#{version}.zip"
  name "GitHub Copilot Language Server"
  desc "Language Server Protocol server for GitHub Copilot"
  homepage "https://github.com/github/copilot-language-server-release"

  depends_on macos: ">= :big_sur"

  binary "copilot-language-server"

  zap trash: "~/.cache/pkg/*/rg",
      rmdir: "~/.cache/pkg"
end