cask "servo" do
  arch arm: "aarch64", intel: "x86_64"

  version "2026-04-28"
  sha256 arm:   "98b8a0a9fe70650359826e820ed673b5d41b9363c382111579cb4fd81dfbd1e4",
         intel: "838dfbe464dc6fa7fa94de3d4878258ac93f5bd65fa1e0db40f361babbb6bb61"

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