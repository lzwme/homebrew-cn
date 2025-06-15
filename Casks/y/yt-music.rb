cask "yt-music" do
  version "1.3.3"
  sha256 "f54fe4892b2df4853f76bdbb94ffe24b3e9878884333da90c3681a52d184cca2"

  url "https:github.comsteve228ukYouTube-Musicreleasesdownload#{version}YT-Music-#{version}.zip"
  name "YouTube Music"
  desc "App wrapper for music.youtube.com"
  homepage "https:github.comsteve228ukYouTube-Music"

  livecheck do
    url "https:raw.githubusercontent.comsteve228ukYouTube-MusicmasterAppcast.xml"
    strategy :sparkle, &:short_version
  end

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "YT Music.app"

  zap trash: [
    "~LibraryCachesuk.co.wearecocoon.YT-Music",
    "~LibraryHTTPStoragesuk.co.wearecocoon.YT-Music",
    "~LibraryHTTPStoragesuk.co.wearecocoon.YT-Music.binarycookies",
    "~LibraryPreferencesuk.co.wearecocoon.YT-Music.plist",
    "~LibrarySaved Application Stateuk.co.wearecocoon.YT-Music.savedState",
    "~LibraryWebKituk.co.wearecocoon.YT-Music",
  ]
end