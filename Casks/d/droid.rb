cask "droid" do
  arch arm: "arm64", intel: "x64"

  version "0.117.0"
  sha256 arm:   "6e35ee49783164f9ba245f17e88d0813a9f2889f67209395599f807b0835e1ba",
         intel: "9ce09726684f334e2a941e6c89a495c86a356273414a0bde4e5f9fbaa4fb9f98"

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