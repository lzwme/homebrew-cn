cask "accord" do
  version "1.7.1"
  sha256 "6dacc0767a03265ea6e9103d40eab4f9c51c8ad7ab6c3b86f9f3d992c630ce80"

  url "https://ghfast.top/https://github.com/evelyneee/accord/releases/download/v#{version}/Accord.app.zip"
  name "accord"
  desc "Discord client written in Swift for modern Macs"
  homepage "https://github.com/evelyneee/accord"

  livecheck do
    url :url
    regex(/v?\.?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :big_sur"

  app "Accord.app"

  zap trash: [
    "~/Library/Application Scripts/red.evelyn.accord",
    "~/Library/Containers/red.evelyn.accord",
  ]
end