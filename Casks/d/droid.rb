cask "droid" do
  arch arm: "arm64", intel: "x64"

  version "0.114.0"
  sha256 arm:   "9ab6052d9cfbf93dca712b952835ab356e6b07d79778ac22fa5638f1a0d7b502",
         intel: "017cc22c7215a21de2f52a88ec73ad6f17987d65c3826495eed82141bfa3d9b1"

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