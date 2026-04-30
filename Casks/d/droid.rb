cask "droid" do
  arch arm: "arm64", intel: "x64"

  version "0.112.0"
  sha256 arm:   "a3e6f14c198947ff99cf9e3cca2a0a422729d978a39ddd69576766b8ce5c56c0",
         intel: "73ec473c54fd45176b4aac8eab5dcf9b3931a09b8bf252361a9b6d050c0164b7"

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