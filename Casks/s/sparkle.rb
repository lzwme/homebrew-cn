cask "sparkle" do
  version "2.6.0"
  sha256 "a520534a2880d02b19179027fb1900b9868889ff996ac53c81ad3a9f5bf2aca8"

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