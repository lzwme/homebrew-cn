cask "servo" do
  arch arm: "aarch64", intel: "x86_64"

  version "2026-04-30"
  sha256 arm:   "03ca6f22f70d358a42c5f00031ce38f23ce1f5ad0793411fd1d2d5e8e03a0ae3",
         intel: "2fd33c4591ef6cf9b00bd9c9f64f3eaa3defac13014c9499360bd5c17e2d2542"

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