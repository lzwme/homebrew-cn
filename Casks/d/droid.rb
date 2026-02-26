cask "droid" do
  arch arm: "arm64", intel: "x64"

  version "0.63.0"
  sha256 arm:   "3b1b993b27ef712669591544a070e3fd7cd85b3d7135f69a98e3f07fb07e2d00",
         intel: "28982332bdd2950034a4c54fcf157c609c28b9952d83c913cee7b113bae8d5b2"

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