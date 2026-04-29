cask "copilot-language-server" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "1.479.0"
  sha256 arm:          "9529df303dfc87cb4129f3fd241e078a9e8473972450fd85b7d70c005061197c",
         intel:        "9b4c16e07dc35608b16b34488e8bfe911e7463fd800b7d31d2e8f97954c832a0",
         arm64_linux:  "8ca3e18e671eacb567c196c43158140f361d071aabd36a6d56f092367c3a3bfb",
         x86_64_linux: "a930d9766988318b990b555f8740a588969e467ed5edb81d104c8a12c6586093"

  url "https://ghfast.top/https://github.com/github/copilot-language-server-release/releases/download/#{version}/copilot-language-server-#{os}-#{arch}-#{version}.zip"
  name "GitHub Copilot Language Server"
  desc "Language Server Protocol server for GitHub Copilot"
  homepage "https://github.com/github/copilot-language-server-release"

  depends_on macos: ">= :big_sur"

  binary "copilot-language-server"

  zap trash: "~/.cache/pkg/*/rg",
      rmdir: "~/.cache/pkg"
end