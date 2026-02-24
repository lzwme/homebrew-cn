cask "servo" do
  arch arm: "aarch64", intel: "x86_64"

  version "2026-02-23"
  sha256 arm:   "409173ad5969e19be57f03dfc022f57f56976a04fcdb736d547dad9c8c9069d9",
         intel: "a4682993d01df261d38e7cf1b829b7ccff988dde3df5739980f2266248c22dfc"

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