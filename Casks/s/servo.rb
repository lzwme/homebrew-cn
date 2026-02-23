cask "servo" do
  arch arm: "aarch64", intel: "x86_64"

  version "2026-02-22"
  sha256 arm:   "aeb648d2d1e66a936a18c399536f696fb40bc1fdd2f8802faa316bbc1dc23711",
         intel: "690af9af7b026246b5b9019f838d2c32065d8da9c9d835d8d88b810dbf0a00fa"

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