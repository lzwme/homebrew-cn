cask "servo" do
  arch arm: "aarch64", intel: "x86_64"

  version "2026-04-26"
  sha256 arm:   "69519ab217cbb5c322a4bd55a7e54c70356fd6fa587a025806f65430b91fe6a8",
         intel: "6e31632e625e08435f608cbf56564fb1dba72444694f5d3ad78e1ff7465eae93"

  url "https://ghfast.top/https://github.com/servo/servo-nightly-builds/releases/download/#{version}/servo-#{arch}-apple-darwin.dmg",
      verified: "github.com/servo/servo-nightly-builds/"
  name "Servo"
  desc "Parallel browser engine"
  homepage "https://servo.org/"

  livecheck do
    url :url
    regex(/^v?(\d+(?:[.-]\d+)+)$/i)
    strategy :github_latest
  end

  disable! date: "2026-09-01", because: :fails_gatekeeper_check

  depends_on macos: ">= :ventura"

  app "Servo.app"

  zap trash: "~/Library/Application Support/Servo"
end