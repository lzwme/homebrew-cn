cask "streammusic" do
  version "1.3.5"
  sha256 "df7a4112e9fcf4144d1ef840aa252046755d341c6879c5dad3485f4cf52667cb"

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