cask "servo" do
  arch arm: "aarch64", intel: "x86_64"

  version "2026-04-27"
  sha256 arm:   "9151e3bdee7992045da7792c873494dfb3cbb34dcf4c0cc2441f571a59d3c1a1",
         intel: "105e4dc73b0ac5f1a3873146514de6a5922ba5a0df6d7507800b8b146c9c6893"

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