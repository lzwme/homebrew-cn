cask "coderabbit" do
  arch arm: "arm64", intel: "x64"

  version "0.3.6"
  sha256 arm:   "b3903f143984436f241b2427895e5e9ed30076378b211fbfa02fc3889a1cc3a9",
         intel: "75a253702ca961b646a906b667706c85a7a8c6b76d3314c94945e00db20bbbfe"

  url "https://cli.coderabbit.ai/releases/#{version}/coderabbit-darwin-#{arch}.zip"
  name "CodeRabbit"
  desc "AI code review CLI"
  homepage "https://www.coderabbit.ai/cli"

  livecheck do
    url "https://cli.coderabbit.ai/releases/latest/VERSION"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  binary "coderabbit"

  zap trash: "~/.coderabbit"
end