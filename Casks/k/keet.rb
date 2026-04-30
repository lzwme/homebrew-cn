cask "keet" do
  arch intel: "-Intel"

  version "4.14.0"
  sha256 arm:   "d44ae97ed56675ca707eba3c80c2a910fac27c5de95df3c170236b9d81e419d7",
         intel: "ca874490068e55b1ecdf8b9fe90b30cb029411061f7f8c12dffe63700ae3b619"

  url "https://static.keet.io/downloads/#{version}/Keet#{arch}.dmg"
  name "keet"
  desc "Peer-to-peer video and text chat"
  homepage "https://keet.io/"

  livecheck do
    url "https://static.keet.io/downloads/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Keet.app"

  zap trash: [
    "~/Library/Application Support/pear",
    "~/Library/Application Support/pear-runtime",
    "~/Library/Saved Application State/io.keet.app.savedState",
  ]
end