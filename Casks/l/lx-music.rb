cask "lx-music" do
  arch arm: "arm64", intel: "x64"

  version "2.11.0"
  sha256 arm:   "475e9a9d722bae3bbda958aceef660dab1b0acc5587b297f9cfce6ac0914d9f3",
         intel: "248040c54fda93e9be43c8d7860626f978b4d0e03547a611d4cba305410fa071"

  url "https:github.comlyswhutlx-music-desktopreleasesdownloadv#{version}lx-music-desktop-#{version}-#{arch}.dmg"
  name "LX Music Assistant Desktop Edition"
  name "洛雪音乐助手桌面版"
  desc "Music app base on Electron & Vue"
  homepage "https:github.comlyswhutlx-music-desktop"

  depends_on macos: ">= :catalina"

  app "lx-music-desktop.app"

  zap trash: [
    "~LibraryApplication Supportlx-music-desktop",
    "~LibraryLogslx-music-desktop",
  ]
end