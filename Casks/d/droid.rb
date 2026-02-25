cask "droid" do
  arch arm: "arm64", intel: "x64"

  version "0.62.0"
  sha256 arm:   "5f8a7e800bc5d34598c382e55b43010d08154f9b09add8d6f93f84ef17a11f79",
         intel: "25f31765cadac7d24f23fd7ded9058f762299c1ddce63dee04955f80453d19f8"

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