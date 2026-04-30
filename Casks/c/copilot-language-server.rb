cask "copilot-language-server" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "1.480.0"
  sha256 arm:          "ef84414487990096ac2b2e93150fafac5ce5b97ed7cbb6d4bcd8e67c8f1ed451",
         intel:        "44ce153b1efc57c501a70ca406ade2fbbc3c95e2a15ff98032d3bb07c5062f12",
         arm64_linux:  "b25b3882da0a0c0054a3cd6461f9de8f4a68b652123791d58fc6f1ad6b7a343e",
         x86_64_linux: "887381509dd98122df2ffadf769ecb036e4254dae3e202854cd3187d01bd632b"

  url "https://ghfast.top/https://github.com/github/copilot-language-server-release/releases/download/#{version}/copilot-language-server-#{os}-#{arch}-#{version}.zip"
  name "GitHub Copilot Language Server"
  desc "Language Server Protocol server for GitHub Copilot"
  homepage "https://github.com/github/copilot-language-server-release"

  depends_on macos: ">= :big_sur"

  binary "copilot-language-server"

  zap trash: "~/.cache/pkg/*/rg",
      rmdir: "~/.cache/pkg"
end