cask "droid" do
  arch arm: "arm64", intel: "x64"

  version "0.119.0"
  sha256 arm:   "71c30b753259f741665fd0e4eb1506d8703174448f70cd7380f08914a226774f",
         intel: "4c2b7134489b3dc21dcd389fae9ca051e4fcdaacf70bc3885b3b60d0025de64c"

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