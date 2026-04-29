cask "coderabbit" do
  arch arm: "arm64", intel: "x64"

  version "0.4.4"
  sha256 arm:   "fbc51ff865dd71b4f08511949f7c0e3a23acd2dd6eec6c02e9b81aca3826626f",
         intel: "e32f899c833973c475218c3688d02d43dd4e18477c23b5ea7b95b0cf414027e5"

  url "https://cli.coderabbit.ai/releases/#{version}/coderabbit-darwin-#{arch}.zip"
  name "CodeRabbit"
  desc "AI code review CLI"
  homepage "https://www.coderabbit.ai/cli"

  livecheck do
    url "https://cli.coderabbit.ai/releases/latest/VERSION"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on :macos

  binary "coderabbit"

  zap trash: "~/.coderabbit"
end