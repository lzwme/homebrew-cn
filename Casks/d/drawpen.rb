cask "drawpen" do
  arch arm: "arm64", intel: "x64"

  version "0.0.48"
  sha256 arm:   "180dfbb1c4d7de16a25f357892257cf1bd3b3b78442c1f5fc04a88b0293ad71b",
         intel: "d0cbc82d523f5ac0699d543fc6e13dc00523ce8bc82d1b2c58827e55c5176c2b"

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