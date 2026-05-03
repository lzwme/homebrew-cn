cask "servo" do
  arch arm: "aarch64", intel: "x86_64"

  version "2026-05-02"
  sha256 arm:   "41d14a7c48c05fe205d6d096112ada7dde57136d43f052594b843707dfeda436",
         intel: "64ce8199913c8ccb27c7f006eaf0b1e61ee1c51ccbf44f3f5a579981d585f6ac"

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