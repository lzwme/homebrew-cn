cask "lx-music" do
  arch arm: "arm64", intel: "x64"

  version "2.11.0"
  sha256 arm:   "475e9a9d722bae3bbda958aceef660dab1b0acc5587b297f9cfce6ac0914d9f3",
         intel: "248040c54fda93e9be43c8d7860626f978b4d0e03547a611d4cba305410fa071"

  url "https://ghfast.top/https://github.com/lyswhut/lx-music-desktop/releases/download/v#{version}/lx-music-desktop-#{version}-#{arch}.dmg"
  name "LX Music Assistant Desktop Edition"
  name "洛雪音乐助手桌面版"
  desc "Music app base on Electron & Vue"
  homepage "https://github.com/lyswhut/lx-music-desktop/"

  disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "lx-music-desktop.app"

  zap trash: [
    "~/Library/Application Support/lx-music-desktop",
    "~/Library/Logs/lx-music-desktop",
  ]
end