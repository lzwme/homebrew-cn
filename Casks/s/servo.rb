cask "servo" do
  arch arm: "aarch64", intel: "x86_64"

  version "2026-05-01"
  sha256 arm:   "df717ceb37e643c65a05c929e48919a84c17bb9cead7eb15bfa6d4f127c6df88",
         intel: "89052c921ef94029bc4aac508647df97dfe5fcb79abebebd315dca0eb19dce8c"

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