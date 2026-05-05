cask "droid" do
  arch arm: "arm64", intel: "x64"

  version "0.118.0"
  sha256 arm:   "45ab7e594d0c886ff985fe9d3979a0e9d83d22f0d56d813855e36e28e78400b3",
         intel: "c48213cddbbdd4076218cdb93f9748a02ace19d6ec5748308cc55a500f792bbd"

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