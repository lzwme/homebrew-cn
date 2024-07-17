cask "youtube-downloader" do
  version "0.13"
  sha256 "a8b7d17d3bf858fe8c6415347d04cb14d7f4a37397c37dd06a848e47b6235984"

  url "https:github.comDenBekeYouTube-Downloader-for-macOSreleasesdownloadv#{version}Youtube.Downloader.zip"
  name "YouTube Downloader"
  desc "Simple menu bar app to download YouTube movies"
  homepage "https:github.comDenBekeYouTube-Downloader-for-macOS"

  depends_on macos: ">= :sierra"

  app "Youtube Downloader.app"

  zap trash: "~LibraryPreferencesdenbeke.Youtube-Downloader.plist"
end