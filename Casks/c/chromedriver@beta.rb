cask "chromedriver@beta" do
  arch arm: "arm64", intel: "x64"

  version "148.0.7778.96"
  sha256 arm:   "3eed34181f9b926a4808574a41484b2e29c90fd57b090a709fc2fe7d475c8d8f",
         intel: "d63c50dca3f3e83df7ac3c5514a3d320db3bf1a38c6b214fdbbc8e83917e267a"

  url "https://storage.googleapis.com/chrome-for-testing-public/#{version}/mac-#{arch}/chromedriver-mac-#{arch}.zip",
      verified: "storage.googleapis.com/chrome-for-testing-public/"
  name "ChromeDriver"
  desc "Automated testing of webapps for Google Chrome"
  homepage "https://chromedriver.chromium.org/"

  livecheck do
    url "https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions.json"
    strategy :json do |json|
      json.dig("channels", "Beta", "version")
    end
  end

  disable! date: "2026-09-01", because: :fails_gatekeeper_check

  conflicts_with cask: "chromedriver"
  depends_on :macos

  binary "chromedriver-mac-#{arch}/chromedriver"

  # No zap stanza required
end