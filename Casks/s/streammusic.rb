cask "streammusic" do
  version "1.3.4"
  sha256 "b33347422b5f823266f853f5b24b804d801dc73743bc5cbb4db12c7ece81bf21"

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