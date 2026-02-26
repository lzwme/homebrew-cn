cask "chromedriver" do
  arch arm: "arm64", intel: "x64"

  version "146.0.7680.31"
  sha256 arm:   "84c3717c0eeba663d0b8890a0fc06faa6fe158227876fc6954461730ccc81634",
         intel: "d453924e87e949f0a13a8db5a2bd826ea7766887fc870b0a9ba18c5fa61203f3"

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