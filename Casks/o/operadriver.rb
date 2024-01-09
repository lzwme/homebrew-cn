cask "operadriver" do
  version "120.0.6099.200"
  sha256 "998b99dcab3b476749fc970e86f47a8571329479937726179b3f0bfac4c94f06"

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