cask "operadriver" do
  version "125.0.6422.143"
  sha256 "55102d14cc093f489793ce70e874a078eddf345b09b9f20c5dd60a9603f8e403"

  url "https:github.comoperasoftwareoperachromiumdriverreleasesdownloadv.#{version}operadriver_mac64.zip"
  name "OperaChromiumDriver"
  desc "Driver for Chromium-based Opera releases"
  homepage "https:github.comoperasoftwareoperachromiumdriver"

  livecheck do
    url :url
    regex(^v?\.?(\d+(?:\.\d+)+)$i)
  end

  binary "operadriver_mac64operadriver"

  # No zap stanza required
end