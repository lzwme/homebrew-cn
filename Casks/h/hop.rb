cask "hop" do
  arch arm: "arm64", intel: "x64"

  version "0.1.9"
  sha256 arm:   "9daf497f6f1fde84317896bd397807ac2d737344ab7e1c5d7ad1af92d814ef90",
         intel: "dd8c8a62370fde182f69ac228d94c50e0ad500410c654cf12f8447d70eada7fa"

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