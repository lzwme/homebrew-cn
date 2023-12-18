cask "pluginval" do
  version "1.0.3"
  sha256 "6bb4d0acc964e775af155ec984c1566dc989dad2a708f64c773706d7baec43af"

  url "https:github.comTracktionpluginvalreleasesdownloadv#{version}pluginval_macOS.zip",
      verified: "github.comTracktionpluginval"
  name "pluginval"
  desc "Cross-platform plugin validator and tester application"
  homepage "https:www.tracktion.comdeveloppluginval"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  app "pluginval.app"

  zap trash: [
    "~LibraryApplication Supportpluginvalpluginval.xml",
    "~LibraryCachespluginvalpluginval_crash.txt",
  ]
end