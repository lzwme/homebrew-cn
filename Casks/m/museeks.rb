cask "museeks" do
  version "0.23.0"
  sha256 "8f9489cc8032155e038fcf93e435a6b11a7bb74ffea80c22e5c5896895b8bf2e"

  url "https://ghfast.top/https://github.com/martpie/museeks/releases/download/#{version}/Museeks_#{version}_universal.dmg",
      verified: "github.com/martpie/museeks/"
  name "Museeks"
  desc "Music player"
  homepage "https://museeks.io/"

  app "Museeks.app"

  zap trash: [
    "~/.config/museeks",
    "~/Library/Application Support/museeks",
    "~/Library/Saved Application State/com.electron.museeks.savedState",
  ]
end