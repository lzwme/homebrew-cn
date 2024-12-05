cask "pluginval" do
  version "1.0.4"
  sha256 "3c4c533bda0c5059eea3ddaea752d757ee2025041f0f47e6bcb0e87f6082b29f"

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