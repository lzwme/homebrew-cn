cask "servo" do
  arch arm: "aarch64", intel: "x86_64"

  version "2026-05-07"
  sha256 arm:   "0a5059299fb46f86de451d39bbd8af5eb4adc940f0f191f3491ecdb9f0e9f1bc",
         intel: "e6ffbc30e69f0b44f6f3c4e08fca6e27a432562c3742a63dd2c48a2f377990d8"

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