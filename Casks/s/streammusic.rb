cask "streammusic" do
  version "1.3.8"
  sha256 "faaebf6df791d774db74fe8bb9f7a44d91f331068a1fe46e2c0621321b523f46"

  url "https:github.comgitboboboStreamMusicreleasesdownloadv#{version}StreamMusic_#{version}.dmg",
      verified: "github.comgitboboboStreamMusic"
  name "StreamMusic"
  desc "Music client compatible with self-hosted music services"
  homepage "https:www.aqzscn.cn"

  depends_on macos: ">= :catalina"

  app "StreamMusic.app"

  zap trash: [
    "~LibraryApplication Scriptscn.aqzscn.streamMusic",
    "~LibraryApplication Supportcn.aqzscn.streamMusic",
    "~LibraryContainerscn.aqzscn.streamMusic",
    "~LibraryPreferencescn.aqzscn.streamMusic.plist",
  ]
end