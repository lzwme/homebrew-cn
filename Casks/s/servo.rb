cask "servo" do
  arch arm: "aarch64", intel: "x86_64"

  version "2026-05-06"
  sha256 arm:   "be87ff56db473c7e92ff6b68ac91171e74cba659b80baf8d6ed8938628da20f8",
         intel: "9e71e665e606ba4d50b2523d87218a47252aadf55d6e9c7239ceb635768c6a5c"

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