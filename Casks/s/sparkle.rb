cask "sparkle" do
  version "2.5.2"
  sha256 "572dd67ae398a466f19f343a449e1890bac1ef74885b4739f68f979a8a89884b"

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