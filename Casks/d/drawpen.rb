cask "drawpen" do
  arch arm: "arm64", intel: "x64"

  version "0.0.49"
  sha256 arm:   "3bbb4b33ef573b05774177ebfc89e36678993102ed244bc3f661d18411e42b7c",
         intel: "dab2b11034d49c4cbf5900ede3655d38a7c3c5859897343b6a6aa3176ffab99f"

  url "https://ghfast.top/https://github.com/DmytroVasin/DrawPen/releases/download/v#{version}/DrawPen-#{version}-#{arch}.dmg"
  name "DrawPen"
  desc "Screen annotation tool"
  homepage "https://github.com/DmytroVasin/DrawPen"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "DrawPen.app"

  zap trash: [
    "~/Library/Application Support/DrawPen",
    "~/Library/Logs/DrawPen",
    "~/Library/Preferences/*drawpen*.plist",
    "~/Library/Saved Application State/*DrawPen*.savedState",
  ]
end