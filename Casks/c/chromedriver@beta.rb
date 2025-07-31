cask "chromedriver@beta" do
  arch arm: "arm64", intel: "x64"

  version "139.0.7258.66"
  sha256 arm:   "94fa1e4fb01e3355f23e427f59d49629df1cbd38e41347faf0738687d71b8c9f",
         intel: "12ed690058dbffa45e0239675a7b70bf232de14f8c95c9a717ca33482cdd52b6"

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

  disable! date: "2026-09-01", because: :unsigned

  conflicts_with cask: "chromedriver"

  binary "chromedriver-mac-#{arch}/chromedriver"

  # No zap stanza required
end