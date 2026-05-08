cask "codex" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "apple-darwin", linux: "unknown-linux-musl"

  version "0.129.0"
  sha256 arm:          "163ffbd8d3f49d0798d5c2224fc6aea8985dfbf9747f16fb54420cb4de373b15",
         intel:        "35738a1d6ff551478d781ad7e1de6cb0883c528296bf2434b2fc1574a00bd82e",
         arm64_linux:  "60ed9e55569a4c287d012cdfbd43742a2bfb130673e22c63b6bb38c68faa7360",
         x86_64_linux: "4a4a28d22dd1f874e2c7b23d9ba13db02bf7ad4ee9a70b9c4eaab618708d0582"

  url "https://ghfast.top/https://github.com/openai/codex/releases/download/rust-v#{version}/codex-#{arch}-#{os}.tar.gz"
  name "Codex"
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"

  livecheck do
    url :url
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  depends_on formula: "ripgrep"

  binary "codex-#{arch}-#{os}", target: "codex"

  zap rmdir: "~/.codex"
end