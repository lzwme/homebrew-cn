cask "droid" do
  arch arm: "arm64", intel: "x64"

  version "0.115.0"
  sha256 arm:   "23f866744ee89469cc2bb381406219271e9c7a6e0b10f145bfa8d58c45653066",
         intel: "275659b685cacebae7ff4c60eb274de87910a1cc7d41cdafacbc85736ec0f85a"

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