cask "sparkle" do
  version "2.6.3"
  sha256 "3c4edb9f1527e056a2a69d24e96c5585d5a0d49f8320796d4caa3a71ab2d9d40"

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