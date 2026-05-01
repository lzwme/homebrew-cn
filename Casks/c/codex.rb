cask "codex" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "apple-darwin", linux: "unknown-linux-musl"

  version "0.128.0"
  sha256 arm:          "f068202e8a898c240c8c068401bccd30ba7b56f61f5ffcd1483d545d47aaf3d5",
         intel:        "c7a08d2011f77e88402a173c473ceec37307a710a681cddd26357c33a025a961",
         arm64_linux:  "3161b4d5304feaf7befbb0fcb41bf9a7ee40e31ba7e3ef36d40a00aa3ba6cbd0",
         x86_64_linux: "886b85e6118c0b43234437ca007fbe923611a53b103d00e0d3ae74aefb20e23a"

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