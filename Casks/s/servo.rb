cask "servo" do
  arch arm: "aarch64", intel: "x86_64"

  version "2026-05-03"
  sha256 arm:   "1157e6177c14827ace0a2b65f644c465b41b34466d2f74210304d03990f7619c",
         intel: "b603bb1ef94a32cd7ca466be15d0842dc418075167c9931f22cf94b3f61e8f1b"

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