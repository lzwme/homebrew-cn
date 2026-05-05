cask "servo" do
  arch arm: "aarch64", intel: "x86_64"

  version "2026-05-04"
  sha256 arm:   "5f96b7326a6533e3f372c7632b9993e034f88040f1db10bad8908445077081bd",
         intel: "f55d2f5291cc58e718feb57344bb37435b04f3afec044be11486ad484c6140b8"

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