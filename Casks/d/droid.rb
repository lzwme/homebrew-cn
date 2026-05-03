cask "droid" do
  arch arm: "arm64", intel: "x64"

  version "0.116.1"
  sha256 arm:   "f7bb7177193c6260dcd56525a91f3fdca923e1a89e1aa4914fb1faefd12242aa",
         intel: "f08a706ce380f44645643d8c0ad32a45053af074a49ade7291bc004f6874b555"

  url "https://downloads.factory.ai/factory-cli/releases/#{version}/darwin/#{arch}/droid"
  name "Droid"
  desc "AI-powered software engineering agent by Factory"
  homepage "https://docs.factory.ai/cli/getting-started/overview"

  livecheck do
    url "https://downloads.factory.ai/factory-cli/LATEST"
    regex(/v?(\d+(?:\.\d+)+)/i)
  end

  depends_on :macos
  depends_on formula: "ripgrep"

  binary "droid"

  zap trash: [
    "~/.factory",
    "~/.local/bin/droid",
  ]
end