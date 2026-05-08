cask "droid" do
  arch arm: "arm64", intel: "x64"

  version "0.121.0"
  sha256 arm:   "d4176f725936808d31c872d926b6b7cd282eed4cbbe964d7469000cfb7b2b0d0",
         intel: "0d8b5a3e48425b154d867e21f8abf7e647d99cb64abca37f074d20e1463d0877"

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