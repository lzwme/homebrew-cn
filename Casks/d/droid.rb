cask "droid" do
  arch arm: "arm64", intel: "x64"

  version "0.64.0"
  sha256 arm:   "66ad33b1e355368d76cdc267e9f412d1549f11a3d6bc23fa1a76af0766b02643",
         intel: "a055529b1d3bd223e6ac5f1d63fd2e8942ae1341f8770a0b0291533ebc9ba864"

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