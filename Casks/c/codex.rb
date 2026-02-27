cask "codex" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "apple-darwin", linux: "unknown-linux-musl"

  version "0.106.0"
  sha256 arm:          "420342f4c074df36571f9f016df77cf7e5926ad191927653a1598e6c7aab26ac",
         intel:        "eb7544a75846eabc25d0ebedc0c8ad4edb670c2b9cadb1397a16107f04988c1d",
         arm64_linux:  "c204fc78805264130fdd630df3fb38a92b9676284b82642510374c363d4679f4",
         x86_64_linux: "157a19dc3b4dffd55f8217e307e067acd588083bcb91177c0d12aa0288d6b9d2"

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