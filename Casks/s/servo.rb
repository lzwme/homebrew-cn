cask "servo" do
  arch arm: "aarch64", intel: "x86_64"

  version "2026-05-05"
  sha256 arm:   "67f7758be6e62ecce25500769a265395ea556a22c351fa002ce64bc7098c8c5d",
         intel: "8f98699894cd1f71eec03788612e5577403a4f8363a5bc827eadedb144f94157"

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