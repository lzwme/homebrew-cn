cask "servo" do
  arch arm: "aarch64", intel: "x86_64"

  version "2026-02-24"
  sha256 arm:   "51446807c328ec4e506384d713d0fd9407ed55e00d73c190c39accb417ec5f20",
         intel: "5f206d2bc31554959ccc8dee5c04f2b54eba71d8ecdf6eb6c7d85616b04af30b"

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