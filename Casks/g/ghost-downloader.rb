cask "ghost-downloader" do
  arch arm: "arm64", intel: "x86_64"

  version "4.5.4"
  sha256 arm:   "8ff17f64804f458fbd00849c9a68e90e52fea43ba46eae8da71a2cadddc1d835",
         intel: "cd853f804438da806217e4d55b45be04a58074471be8c05fcf5aeda668f69c8b"

  url "https://ghfast.top/https://github.com/XiaoYouChR/Ghost-Downloader-3/releases/download/v#{version}/Ghost-Downloader-v#{version}-macOS-#{arch}.dmg"
  name "Ghost Downloader"
  desc "Cross-platform multithreaded download manager"
  homepage "https://gd.xychr.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "Ghost Downloader.app"

  uninstall quit: [
    "com.xychr.ghostdownloader",
    "io.github.xiaoyouchr.GhostDownloader",
  ]

  zap trash: [
    "~/Library/Application Support/GhostDownloader",
    "~/Library/Preferences/io.github.xiaoyouchr.GhostDownloader.plist",
  ]
end