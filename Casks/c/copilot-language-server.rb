cask "copilot-language-server" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "1.477.0"
  sha256 arm:          "c2e7edc1c33ec19590899b7f0d5a8882071eb93d2458ffb3a838ea363de43318",
         intel:        "48ea1675ba50232054bb5bee62f5bdcb141b5c63107c5fbc124510d9a039ddd0",
         arm64_linux:  "8f1616a301f9948e21148112d0fe36d0974865eec8e433eea4781dd50a6f0421",
         x86_64_linux: "79db50ccf48a6ce47d709c8b11a8a73df22f34bd692541e64cf8f747acff4a16"

  url "https://ghfast.top/https://github.com/github/copilot-language-server-release/releases/download/#{version}/copilot-language-server-#{os}-#{arch}-#{version}.zip"
  name "GitHub Copilot Language Server"
  desc "Language Server Protocol server for GitHub Copilot"
  homepage "https://github.com/github/copilot-language-server-release"

  depends_on macos: ">= :big_sur"

  binary "copilot-language-server"

  zap trash: "~/.cache/pkg/*/rg",
      rmdir: "~/.cache/pkg"
end