cask "sparkle" do
  version "2.7.0"
  sha256 "09fed60cca507d2dc542c86c22e525598af5483954a5c66366ce039647ec88e9"

  url "https:github.comsparkle-projectSparklereleasesdownload#{version}Sparkle-#{version}.tar.xz",
      verified: "github.comsparkle-projectSparkle"
  name "Sparkle"
  desc "Software update framework for Cocoa developers"
  homepage "https:sparkle-project.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

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