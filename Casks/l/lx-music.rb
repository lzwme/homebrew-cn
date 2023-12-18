cask "lx-music" do
  arch arm: "arm64", intel: "x64"

  version "2.5.0"
  sha256 arm:   "c1649287fecf525b8fd9c72fe98c4792a5fc9e71ff52171193f2217b1230ec3e",
         intel: "3bcac495a030a2a0c2105ee48065b8c77edceb9d4ff4eb5461daac0a70ee806c"

  url "https:github.comlyswhutlx-music-desktopreleasesdownloadv#{version}lx-music-desktop-#{version}-#{arch}.dmg"
  name "LX Music Assistant Desktop Edition"
  name "洛雪音乐助手桌面版"
  desc "Music app base on Electron & Vue"
  homepage "https:github.comlyswhutlx-music-desktop"

  app "lx-music-desktop.app"

  zap trash: [
    "~LibraryApplication Supportlx-music-desktop",
    "~LibraryLogslx-music-desktop",
  ]
end