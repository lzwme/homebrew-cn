cask "streammusic" do
  version "1.3.7"
  sha256 "3ce0573b78fedd36a37ba0a1175efee9aedccb033a6ad2f299c428e8a4c4dd8d"

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