cask "sparkle" do
  version "2.6.2"
  sha256 "2300a7dc2545a4968e54621b7f351d388ddf1a5cb49e79f6c99e9a09d826f5e8"

  url "https:github.comsparkle-projectSparklereleasesdownload#{version}Sparkle-#{version}.tar.xz",
      verified: "github.comsparkle-projectSparkle"
  name "Sparkle"
  desc "Software update framework for Cocoa developers"
  homepage "https:sparkle-project.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Sparkle Test App.app"
  binary "sparkle.appContentsMacOSsparkle"

  zap trash: [
    "~LibraryApplication Scriptsorg.sparkle-project.Downloader",
    "~LibraryApplication Scriptsorg.sparkle-project.SparkleTestApp",
    "~LibraryContainersorg.sparkle-project.Downloader",
    "~LibraryContainersorg.sparkle-project.SparkleTestApp",
    "~LibraryPreferencesorg.sparkle-project.SparkleTestApp.plist",
  ]
end