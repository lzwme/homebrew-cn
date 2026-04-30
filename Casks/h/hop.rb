cask "hop" do
  arch arm: "arm64", intel: "x64"

  version "0.1.10"
  sha256 arm:   "b6cc2d6ec6aa554153855f2552e79997cc2cda87f00a442e228e29bfdc673dc8",
         intel: "51d9c073d336d01572b544481829bf14266f9fcd1c2cf2d1769e7a1ffe4c9e23"

  url "https://ghfast.top/https://github.com/golbin/hop/releases/download/v#{version}/HOP-macos-#{arch}.dmg",
      verified: "github.com/golbin/hop/"
  name "HOP"
  desc "View and edit HWP documents"
  homepage "https://golbin.github.io/hop/"

  depends_on :macos

  app "HOP.app"

  zap trash: [
    "~/Library/Application Support/net.golbin.hop",
    "~/Library/Caches/net.golbin.hop",
    "~/Library/Logs/net.golbin.hop",
    "~/Library/WebKit/net.golbin.hop",
  ]
end