cask "droid" do
  arch arm: "arm64", intel: "x64"

  version "0.109.3"
  sha256 arm:   "97a83e3587d35fa21fe7a34ae2bc219c25e698543462e3fcdcb1e396221ed270",
         intel: "2d01061cf5a5b4e401fab88a454ab075a76eb7c157e7aefdbd150c0fcd367588"

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