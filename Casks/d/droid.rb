cask "droid" do
  arch arm: "arm64", intel: "x64"

  version "0.61.0"
  sha256 arm:   "65b2637964fe35ea54025a6fab83d789d83ad5688bbc91336e3870fd02db9aab",
         intel: "c59624eecc7611f4a379027e6a0995c7673adc8410704bd74c08472cfb821e9b"

  url "https://downloads.factory.ai/factory-cli/releases/#{version}/darwin/#{arch}/droid"
  name "Droid"
  desc "AI-powered software engineering agent by Factory"
  homepage "https://docs.factory.ai/cli/getting-started/overview"

  livecheck do
    url "https://downloads.factory.ai/factory-cli/LATEST"
    regex(/v?(\d+(?:\.\d+)+)/i)
  end

  depends_on formula: "ripgrep"

  binary "droid"

  zap trash: [
    "~/.factory",
    "~/.local/bin/droid",
  ]
end