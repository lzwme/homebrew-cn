cask "droid" do
  arch arm: "arm64", intel: "x64"

  version "0.65.0"
  sha256 arm:   "289cd8689e01f2367706a790162c26b468a3600a023f26831c79cea905b89241",
         intel: "2cafeb6c407c44d0cdf11896f612f27f45ad5c9594c10a1755f5f3bf6cc4b55c"

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