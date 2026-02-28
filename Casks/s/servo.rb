cask "servo" do
  arch arm: "aarch64", intel: "x86_64"

  version "2026-02-27"
  sha256 arm:   "73a642c56bf012302b3985c9d75dcfdd702e35396ae6a968f14f3457ac43bbef",
         intel: "29e5b2bd036490961900f8d4f1fdbceced42fdf6dca4acfa61abaeaa4f387656"

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