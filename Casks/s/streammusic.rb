cask "streammusic" do
  version "1.3.6"
  sha256 "af8cd445ad13d55365a0ee39abbecc490291c1f8239fd19b000816be25be46e6"

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