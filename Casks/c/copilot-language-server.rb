cask "copilot-language-server" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "1.481.0"
  sha256 arm:          "b6e3148c696e498d96d6579b648e01e3303e95b06247ad699613b96ab475836b",
         intel:        "c7a3a261ad8b3fa93a2216e52b21a1c2ee70a82d45f1272f673a1cdc7fdd3db1",
         arm64_linux:  "9f2f7dafbca4f35c0c075f70d20ace742be35d11621b98054abbc516c6290e9a",
         x86_64_linux: "2673e021b5a981ec3e77d3ad11ead15081b1a041dd2b9225fdc9f8d25bf15564"

  url "https://ghfast.top/https://github.com/github/copilot-language-server-release/releases/download/#{version}/copilot-language-server-#{os}-#{arch}-#{version}.zip"
  name "GitHub Copilot Language Server"
  desc "Language Server Protocol server for GitHub Copilot"
  homepage "https://github.com/github/copilot-language-server-release"

  depends_on macos: ">= :big_sur"

  binary "copilot-language-server"

  zap trash: "~/.cache/pkg/*/rg",
      rmdir: "~/.cache/pkg"
end