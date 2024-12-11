cask "youtube-downloader" do
  version "0.18"
  sha256 "94f84805944b9855db2384a6eee219a08fecf551edddaa045ce020f8ab8448ec"

  url "https:github.comDenBekeYouTube-Downloader-for-macOSreleasesdownloadv#{version}Youtube.Downloader.zip"
  name "YouTube Downloader"
  desc "Simple menu bar app to download YouTube movies"
  homepage "https:github.comDenBekeYouTube-Downloader-for-macOS"

  depends_on macos: ">= :sierra"

  app "Youtube Downloader.app"

  zap trash: "~LibraryPreferencesdenbeke.Youtube-Downloader.plist"
end