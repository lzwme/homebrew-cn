cask "servo" do
  arch arm: "aarch64", intel: "x86_64"

  version "2026-02-25"
  sha256 arm:   "29371dcbcd207bac2c39c1e548d84e1726bfa5cf15ae23861b9247d02a09fad6",
         intel: "3b722879d6ebaa6ffd9386de42bbccc6e7fd446e83d2432b5cf3f4bb1c473b1b"

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