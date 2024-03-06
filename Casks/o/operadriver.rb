cask "operadriver" do
  version "122.0.6261.95"
  sha256 "524b5bdf2ce1db3570e5d47dfd7f668339397fbbcec54c2447eff92ab20e3339"

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