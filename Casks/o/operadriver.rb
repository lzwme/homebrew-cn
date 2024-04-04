cask "operadriver" do
  version "123.0.6312.59"
  sha256 "eeae55ab022a501bccbd3054cc5c8a8ad6931f2c6c4446bdf193265a5fccb378"

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