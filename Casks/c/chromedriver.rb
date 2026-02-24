cask "chromedriver" do
  arch arm: "arm64", intel: "x64"

  version "145.0.7632.117"
  sha256 arm:   "25d09ebbca90628b480e95e0d1541818f8e7646d0b77fa81c6258fc13c0613d0",
         intel: "fea60867b12a3cc4206ba4c9dea49d9ab6ef271653a450675526cc9afc09f0d4"

  url "https://storage.googleapis.com/chrome-for-testing-public/#{version}/mac-#{arch}/chromedriver-mac-#{arch}.zip",
      verified: "storage.googleapis.com/chrome-for-testing-public/"
  name "ChromeDriver"
  desc "Automated testing of webapps for Google Chrome"
  homepage "https://chromedriver.chromium.org/"

  livecheck do
    url "https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions.json"
    strategy :json do |json|
      json.dig("channels", "Stable", "version")
    end
  end

  disable! date: "2026-09-01", because: :fails_gatekeeper_check

  conflicts_with cask: "chromedriver@beta"

  binary "chromedriver-mac-#{arch}/chromedriver"

  # No zap stanza required
end