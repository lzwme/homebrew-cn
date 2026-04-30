cask "gitkraken-cli" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"

  version "3.1.61"
  sha256 arm:          "4ad18041c17d3bc777421b7747b67b371ee5ea855118eaa83b3b951206978ffa",
         intel:        "68774ea01efb950a7295fb7231f6858ed2d5d2ecbc4168282e04435edd52efe0",
         arm64_linux:  "64661d1a1e9f27c7f700c4ca85094e7084a5ebae5d7bf792550522eef3167dc0",
         x86_64_linux: "8ea04a57a0eb145eb1bbfae160a25c64def210f862f7c843b453831ae105729b"

  url "https://ghfast.top/https://github.com/gitkraken/gk-cli/releases/download/v#{version}/gk_#{version}_#{os}_#{arch}.zip"
  name "GitKraken CLI"
  desc "CLI for GitKraken"
  homepage "https://github.com/gitkraken/gk-cli"

  binary "gk"

  zap trash: "~/.gitkraken"
end