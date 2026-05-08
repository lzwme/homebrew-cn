cask "copilot-language-server" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "1.483.0"
  sha256 arm:          "1d1ab7cf4c1b81897f8e021148911acd620e11deac26d984a129edc7e1e42fe6",
         intel:        "696cac505e7804cf68ffc8b48035b45b8f26880c942712a1710e35e8566c94bf",
         arm64_linux:  "2e7d1e7579451f1272cd6b5e4748b978dcf8ec63764903952ac1054c41619e3d",
         x86_64_linux: "199fa93f4ef7f3a9ec17cd204af7698ce667efcf8b5fefcf78fdd62ed45025fe"

  url "https://ghfast.top/https://github.com/github/copilot-language-server-release/releases/download/#{version}/copilot-language-server-#{os}-#{arch}-#{version}.zip"
  name "GitHub Copilot Language Server"
  desc "Language Server Protocol server for GitHub Copilot"
  homepage "https://github.com/github/copilot-language-server-release"

  depends_on macos: ">= :big_sur"

  binary "copilot-language-server"

  zap trash: "~/.cache/pkg/*/rg",
      rmdir: "~/.cache/pkg"
end