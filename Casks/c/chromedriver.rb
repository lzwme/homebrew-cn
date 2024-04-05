cask "chromedriver" do
  arch arm: "arm64", intel: "x64"

  version "123.0.6312.105"
  sha256 arm:   "8698f40d8c88397541db514fa9a6f5e1e0552bbd55b877e658fd63f102a8cfce",
         intel: "ff343613d6fd11aa31fffd3fe3c71bcc8a9b2a47ee4b9d6d24206921b77498a8"

  url "https://storage.googleapis.com/chrome-for-testing-public/#{version}/mac-#{arch}/chromedriver-mac-#{arch}.zip",
      verified: "storage.googleapis.com/chrome-for-testing-public/"
  name "ChromeDriver"
  desc "Automated testing of webapps for Google Chrome"
  homepage "https://chromedriver.chromium.org/"

  livecheck do
    url "https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions-with-downloads.json"
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :json do |json, regex|
      json["channels"]["Stable"]["version"]&.scan(regex) { |match| match[0] }
    end
  end

  conflicts_with cask: "chromedriver-beta"

  binary "chromedriver-mac-#{arch}/chromedriver"

  # No zap stanza required
end