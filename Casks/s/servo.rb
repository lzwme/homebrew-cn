cask "servo" do
  arch arm: "aarch64", intel: "x86_64"

  version "2026-02-26"
  sha256 arm:   "d9e9e1831947b156a00658e0544fb12c1eeaacbe8594a5d35435a28dd6fbf8b5",
         intel: "b20af13b3bc2be790e7321b7e2f3a024ad58d150ccb0becad0b14c7dbfeed107"

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