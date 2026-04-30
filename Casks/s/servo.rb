cask "servo" do
  arch arm: "aarch64", intel: "x86_64"

  version "2026-04-29"
  sha256 arm:   "6b730f3950d09a28c04e63b8db5cf23f74ef222c7824ab87b044b73727e9f527",
         intel: "c27d43593205ce28538b4b7c06470a3943e8aef6e79749c96fd82a2313702430"

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